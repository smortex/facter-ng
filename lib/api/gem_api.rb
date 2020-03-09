# frozen_string_literal: true

require "#{ROOT_DIR}/lib/api/logging_api"
require "#{ROOT_DIR}/lib/api/external_facts_api"
require "#{ROOT_DIR}/lib/api/custom_facts_api"

module GemApi
  include LoggingApi
  include ExternalFactsApi
  include CustomFactsApi

  def [](name)
    fact(name)
  end

  def add(name, options = {}, &block)
    options[:fact_type] = :custom
    LegacyFacter.add(name, options, &block)
  end

  def clear
    LegacyFacter.clear
  end

  def fact(name)
    fact = Facter::Util::Fact.new(name)
    val = value(name)
    fact.add({}) { setcode { val } }
    fact
  end

  def reset
    LegacyFacter.reset
  end

  def to_hash
    @options.priority_options[:to_hash] = true
    @options.refresh

    log_blocked_facts

    resolved_facts = Facter::FactManager.instance.resolve_facts
    Facter::CacheManager.invalidate_all_caches
    Facter::FactCollection.new.build_fact_collection!(resolved_facts)
  end

  def value(user_query)
    @options.refresh([user_query])
    user_query = user_query.to_s
    resolved_facts = Facter::FactManager.instance.resolve_facts([user_query])
    Facter::CacheManager.invalidate_all_caches
    fact_collection = Facter::FactCollection.new.build_fact_collection!(resolved_facts)
    splitted_user_query = Facter::Utils.split_user_query(user_query)
    fact_collection.dig(*splitted_user_query)
  end

  def version
    version_file = ::File.join(ROOT_DIR, 'VERSION')
    ::File.read(version_file).strip
  end

  private

  def log_blocked_facts
    block_list = Facter::BlockList.instance.block_list
    @logger.debug("blocking collection of #{block_list.join("\s")} facts") if block_list.any? && Options[:block]
  end
end

# frozen_string_literal: true

require 'pathname'

ROOT_DIR = Pathname.new(File.expand_path('..', __dir__)) unless defined?(ROOT_DIR)

require "#{ROOT_DIR}/lib/framework/core/file_loader"
require "#{ROOT_DIR}/lib/framework/core/options/options_validator"

require "#{ROOT_DIR}/lib/api/cli_api"
require "#{ROOT_DIR}/lib/api/gem_api"

module Facter
  class ResolveCustomFactError < StandardError; end

  @options = Options.instance
  Log.add_legacy_logger(STDOUT)
  @logger = Log.new(self)

  class << self
    include CliApi
    include GemApi

    def core_value(user_query)
      user_query = user_query.to_s
      resolved_facts = Facter::FactManager.instance.resolve_core([user_query])
      fact_collection = FactCollection.new.build_fact_collection!(resolved_facts)
      splitted_user_query = Facter::Utils.split_user_query(user_query)
      fact_collection.dig(*splitted_user_query)
    end

    def method_missing(name, *args, &block)
      @logger.error(
        "--#{name}-- not implemented but required \n" \
        'with params: ' \
        "#{args.inspect} \n" \
        'with block: ' \
        "#{block.inspect}  \n" \
        "called by:  \n" \
        "#{caller} \n"
      )
      nil
    end
  end
end

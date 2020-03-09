# frozen_string_literal: true

module CliApi
  def to_user_output(cli_options, *args)
    @options.priority_options = { is_cli: true }.merge!(cli_options.map { |(k, v)| [k.to_sym, v] }.to_h)
    @options.refresh(args)
    @logger.info("executed with command line: #{ARGV.drop(1).join(' ')}")
    log_blocked_facts

    resolved_facts = Facter::FactManager.instance.resolve_facts(args)
    Facter::CacheManager.invalidate_all_caches
    fact_formatter = Facter::FormatterFactory.build(@options)

    status = error_check(args, resolved_facts)

    [fact_formatter.format(resolved_facts), status || 0]
  end

  private

  def log_errors(missing_names)
    missing_names.each do |missing_name|
      @logger.error("fact \"#{missing_name}\" does not exist.", true)
    end
  end

  def error_check(args, resolved_facts)
    if Facter::Options.instance[:strict]
      missing_names = args - resolved_facts.map(&:user_query).uniq
      if missing_names.count.positive?
        status = 1
        log_errors(missing_names)
      else
        status = nil
      end
    end

    status
  end
end

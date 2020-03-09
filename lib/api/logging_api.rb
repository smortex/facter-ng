# frozen_string_literal: true

module LoggingApi
  def debug(msg)
    return unless debugging?

    @logger.debug(msg)
    nil
  end

  def on_message(&block)
    Facter::Log.on_message(&block)
  end

  def debugging?
    Facter::Options[:debug]
  end

  def debugging(debug_bool)
    @options.priority_options[:debug] = debug_bool
    @options.refresh

    debug_bool
  end

  def trace?
    LegacyFacter.trace?
  end

  def trace(bool)
    LegacyFacter.trace(bool)
  end
end

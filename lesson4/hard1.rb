class SecretFile
  def initialize(secret_data)
    @data = secret_data
    @sec_log = SecurityLogger.new
  end

  def data
    @sec_log.create_log_entry(#arguments)
    @data
    end
end

class SecurityLogger
  def initialize
    @log = []
  end

  def create_log_entry
    @log << #arguments
  end
end
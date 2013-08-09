class WiFlyProvider < Provider

  IP = "ip";
  PORT = "port";
  TIMEOUT = "timeout";
  LOG_PATH = "log_path";

  #after_initialize :init

  # Provide config value by key.
  def get_config(key)
    Rails.logger.debug("Get config for key=#{key}")
    result = provider_config.select { |f| f.key.upcase == key.upcase }
    if (result.size > 0)
      config = result[0].value
      config = config.strip if config
    else
      nil
    end
    Rails.logger.debug("Config value=#{config}")
    config
  end

  def get_connector
    if (@connector == nil)
      @connector = WiflyConnector.new(get_config(IP),
                                      get_config(PORT),
                                      get_config(TIMEOUT),
                                      get_config(LOG_PATH))
    end
    @connector
  end

end
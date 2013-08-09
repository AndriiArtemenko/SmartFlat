class WiflyConnector

  require 'net/telnet'

  CMD_MODE = "$$$"
  CMD_EXIT = "exit"
  CMD_UART_INVALID = "unknown"

  TIMEOUT = 10
  LOG_PATH = "#{self.to_s}.log"

  #constructor
  def initialize(host, port, timeout = TIMEOUT, log_path = LOG_PATH)
    if (host == nil || port == nil)
      raise ArgumentError, "host and port must be not nil"
    end
    @host = host
    @port = port

    (timeout == nil) ? @timeout = TIMEOUT : @timeout = timeout

    (log_path == nil) ? @log_path = LOG_PATH : @log_path = log_path
  end

  # Connect to telnet host .
  def connect
    Rails.logger.debug("WiflyConnector connect start")
    Net::Telnet::new("Host"       => @host,
                     "Port"       => @port,
                     "Timeout"    => @timeout,
                     "Output_log" => @log_path)
    Rails.logger.debug("WiflyConnector connect end")
  end

  # execute command in programm mode.
  def execute(command)
    result = nil
    host = connect
    if host != nil
      begin
        host.puts(CMD_MODE)
        result = host.cmd(command)
      ensure
        disconnect(host)
      end
    end
    result
  end

  # execute command in UART mode.
  def uart(command)
    result = nil
    host = connect
    if host != nil
      begin
        result = host.cmd(CMD_UART_INVALID)
        if (result.include? CMD_UART_INVALID)
          result = host.cmd(command)
        else
          raise IOError, "UART does not responding"
        end
      ensure
        disconnect(host)
      end
    end
    result
  end

  # Disconnect connection.
  def disconnect(connection)
    if connection != nil
      begin
        connection.puts(CMD_EXIT)
      ensure
        connection.close
      end      
    end
  end

end
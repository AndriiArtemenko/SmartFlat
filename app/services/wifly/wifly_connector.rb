class WiflyConnector

  require 'net/telnet'

  CMD_MODE = "$$$"
  CMD_EXIT = "exit"
  CMD_UART_INVALID = "unknown"
  CMD_HELLO = "*HELLO*"

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
  def connect(prompt)
    Rails.logger.debug("WiflyConnector connect start")
    result = Net::Telnet::new("Host"       => @host,
                     "Port"       => @port,
                     "Timeout"    => @timeout,
                     "Output_log" => @log_path,
                     "Prompt" => prompt)
    Rails.logger.debug("WiflyConnector connect end")
    result
  end

  # execute command in programm mode.
  def execute(command)
    result = nil
    host = connect( /[$%#>] \z/n)
    if host != nil
      begin
        host.puts(CMD_MODE)
        sleep(2)
        result = host.cmd(command)
      ensure
        # host.cmd(CMD_EXIT)
        disconnect(host)
      end
    end
    result
  end

  # execute command in UART mode.
  def uart(command)
    result = nil
    host = connect(/\z/n)
    if host != nil
      begin
        result = host.cmd(command)
        if (result.include?(CMD_UART_INVALID) || result.include?(CMD_HELLO))
          sleep(2);
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
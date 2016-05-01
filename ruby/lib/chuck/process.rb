require 'ruby-osc'

module Chuck
  CHUCK_DIR = Dir.new File.expand_path(File.dirname(__FILE__)+'/scripts')
  class Process
    def initialize(file, port, *chuck_args)
      @client = OSC::Client.new 'localhost', port
      @process = Process.spawn "chuck --loop #{CHUCK_DIR.to_path + file}:#{port}:#{chuck_args.join ':'}"
    end

    def send(end_point, *params)
      @client.send(OSC::Message.new(end_point, *params))
    end

    def kill
      Process.kill 'SIGINT', @process
    end
  end
end

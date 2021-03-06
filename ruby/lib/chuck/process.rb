require 'osc-ruby'

module Chuck
  CHUCK_DIR = Dir.new File.expand_path(File.dirname(__FILE__)+'/scripts')
  class Process
    def initialize(file, port, *chuck_args)
      @port = port
      @process = ::Process.spawn "chuck --loop #{CHUCK_DIR.to_path+'/'+file}:#{port}:#{chuck_args.join ':'}"
      sleep 1 # wait for chuck to spool up
    end

    def send(end_point, *params)
      client = OSC::Client.new 'localhost', @port
      client.send(OSC::Message.new(end_point, *params))
    end

    def kill
      ::Process.kill 'KILL', @process
    end
  end
end

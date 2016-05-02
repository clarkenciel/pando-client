module OSC
  class PandoServer
    def initialize(port, **callbacks)
      @server = OSC::EMServer.new port
      callbacks.each do |addr, func|
        @server.add_method(addr, &fun)
      end
      @proc = Thread.new { @server.run }
    end

    def stop
      @proc.kill
    end
  end
end

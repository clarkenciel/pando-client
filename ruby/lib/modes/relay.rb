module Modes
  class Relay
    def initialize(pando_server, room_name, user_name='pando_bot', chuck_port=5375)
      @user_list = []
      @broadcast = OSC::BroadcastClient.new(chuck_port)
      @osc_server = OSC::PandoServer.new(
        chuck_port-1,
        { '*' => ->(message) do; end })
                                           
      @socket = PandoSocket.connect(
        pando_server, room_name, user_name,
        onmessage = ->(m) do
          message = JSON.parse(m)
          @broadcast.send '/message', message[:userName], message[:frequency]
        end,
        onerror = ->(*error) do
          puts "Relay socket error: #{error}"
          stop
        end)
    end

    def stop
      @broadcast.kill
      @osc_server.stop
      @socket.cancel
    end    
  end
end

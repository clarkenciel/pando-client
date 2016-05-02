module Modes
  class Relay
    def initialize(pando_server, room_name, chuck_port=5375)
      @user_list = []
      @broadcast = OSC::BroadcastClient.new(chuck_port)
      @socket = PandoSocket.connect(
        pando_server, room_name, 'observer',
        onmessage = ->(m) {
          @broadcast.send '/message', message[:userName], message[:frequency]
        })
    end

    def stop
      @broadcast.kill
      @socket.kill
    end    
  end
end

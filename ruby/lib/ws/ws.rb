require 'websocket-eventmachine-client'

class PandoSocket  
  attr_reader :ws
  def self.connect(pando_server, room_name, user_name,
                   onopen=->(r){default_open(r)},
                   onmessage=->(m,t){default_message(m,t)},
                   onclose=->(c,r){default_close(c,r)},
                   onerror=->(e){default_error(e)})
    @ws = nil
    Thread.new do
      EM.run do
        @ws = WebSocket::EventMachine::Client.connect(
          :uri => "ws://#{pando_server}/pando/api/connect/#{room_name}/#{user_name}")
        @ws.onopen(&onopen)
        @ws.onmessage(&onmessage)
        @ws.onclose(&onclose)
        @ws.onerror(&onerror)

        EventMachine.add_periodic_timer(1) do
          @ws.send(JSON.generate({type: "ping",
                                  userName: user_name,
                                  roomName: room_name}))
        end
      end
    end
  end

  def default_open(response)
    puts "Socket open #{response}"
  end

  def default_message(message, type)
    puts "Received message: #{message}"
  end

  def default_close(code, reason)
    puts "Socket closed! #{code}, #{reason}"
  end

  def default_error(error)
    puts "Socket error! #{error}"
  end

  def send(packet)
    @ws.send(packet.to_json) unless !@ws
  end

  def logout(room_name, user_name)
    
  end
end

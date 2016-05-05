require 'websocket-eventmachine-client'

# Create a websocket connection as a user to a room
# on a Pando instance.
class PandoSocket  
  attr_reader :ws
  def initialize(pando_server, room_name, user_name,
                   onopen=->(r){default_open(r)},
                   onmessage=->(m,t){default_message(m,t)},
                   onclose=->(c,r){default_close(c,r)},
                   onerror=->(e){default_error(e)})
    @ws = nil
    @server = pando_server
    @room_name = room_name
    @user_name = user_name
    @thread = Thread.new do
      EM.run do
        @ws = WebSocket::EventMachine::Client.connect(
          :uri => "ws://#{@server}/pando/api/connect/#{@room_name}/#{@user_name}")
        @ws.onopen(&onopen)
        @ws.onmessage(&onmessage)
        @ws.onclose(&onclose)
        @ws.onerror(&onerror)

        EventMachine.add_periodic_timer(1) do
          @ws.send({'type' => "ping",
                    'userName' => user_name,
                    'roomName' => room_name}.to_json)
        end
      end
    end
  end
  
  def self.connect(*args)
    new(*args)
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

  def send_message(packet)    
    p = packet.to_json
    @ws.send(p) unless !@ws
  end

  def logout(room_name, user_name)
    @ws.close

    Pando.delete_user(@server, room_name, user_name)
  end

  def cancel
    @ws.close
    @thread.cancel
  end
end

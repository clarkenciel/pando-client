require 'websocket-eventmachine-client'

module PandoSocket
  def self.connect(pando_server, room_name, user_name,
                   onopen=->(r){default_open(r)},
                   onmessage=->(m,t){default_message(m,t)},
                   onclose=->(c,r){default_close(c,r)},
                   onerror=->(e){default_error(e)})
    Thread.new do
      EM.run do
        ws = WebSocket::EventMachine::Client.connect(:uri => "ws://#{pando_server}/pando/api/connect/#{room_name}/#{user_name}")

        ws.onopen(&onopen)
        ws.onmessage(&onmessage)
        ws.onclose(&onclose)
        ws.onerror(&onerror)

        EventMachine.add_periodic_timer(1) do
          ws.send(JSON.generate({type: "ping",
                                 userName: user_name,
                                 roomName: room_name}))
        end
      end
    end
  end

  def self.default_open(response)
    puts "Socket open #{response}"
  end

  def self.default_message(message, type)
    puts "Received message: #{message}"
  end

  def self.default_close(code, reason)
    puts "Socket closed! #{code}, #{reason}"
  end

  def self.default_error(error)
    puts "Socket error! #{error}"
  end
end

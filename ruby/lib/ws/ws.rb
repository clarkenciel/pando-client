require 'websocket-eventmachine-client'

module PandoSocket
  def self.connect(pando_server, room_name, user_name,
                   onopen=->(){default_open},
                   onmessage=->(m){default_message(m)},
                   onclose=->(){default_close},
                   onerror=->(e){default_error(e)})
    Thread.new do
      EM.run do
        ws = WebSocket::EventMachine::Client.connect(
          :uri => "ws://#{pando_server}/pando/api/connect/#{room_name}/#{user_name}")

        ws.onopen(&onopen)
        ws.onmessage(&onmessage)
        ws.onclose(&onclose)
        ws.onerror(&onerror)
      end
    end
  end

  def self.default_open
    puts "Socket open"
  end

  def self.default_message(message)
    puts "Received message: #{message}"
  end

  def self.default_close
    puts "Socket closed!"
  end

  def self.default_error(error)
    puts "Socket error! #{error}"
  end
end

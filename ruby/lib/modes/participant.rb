module Modes
  class Participant
    def initialize(pando_server, room_name, user_name)
      @responses = {}
      @server = pando_server
      @room_name = room_name
      @user_name = user_name
      @frequency = nil
      @coord = nil
      @socket = PandoSocket.connect(
        pando_server, room_name, user_name,
        onopen = ->(response) do
        end,
        onmessage = ->(message, type) do
          message = JSON.parse message
          @responses.each { |_,f| f(message) }
        end,
        onerror = ->(*error) do
          puts "An error has occurred: #{error}"
          #exit
        end)
    end

    def add_responses(procs)
      @responses.merge procs
      self
    end

    def add_actions(procs)
      procs.each do |period, func|xxo
        EventMachine.add_periodic_timer(period, &func)
      end
      self
    end

    def send_message(message)
      @socket.send_message({'type' => 'message',
                    'roomName'=> @room_name,
                    'userName' => @user_name,
                    'message' => message,
                    'frequency' => @frequency,
                    'coord' => @coord
                   })
    end

    def stop
      @socket && @socket.logout(@room_name, @user_name)
    end
  end
end

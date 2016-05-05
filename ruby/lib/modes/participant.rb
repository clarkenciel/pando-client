module Modes
  class Participant
    def initialize(pando_server, room_name, user_name)
      @responses = {}
      @server = pando_server
      @room_name = room_name
      @user_name = user_name
      @socket = PandoSocket.connect(
        pando_server, room_name, user_name,
        onopen = ->(response) do
        end,
        onmessage = ->(message, type) do
          message = JSON.parse message
          @responses.each { |a| a(message) }
        end,
        onerror = ->(*error) do
          puts "An error has occurred: #{error}"
          exit
        end)
    end

    def add_responses(procs)
      @responses.merge procs
      self
    end

    def add_actions(procs)
      procs.each do |period, func|
        EventMachine.add_periodic_timer(period, &func)
      end
      self
    end

    def send(message)
      @socket.send({"roomName"=> @room_name,
                    "userName" => @user_name,
                    "message" => message})
    end

    def stop
      @socket && @socket.logout(@room_name, @user_name) && @socket.cancel
    end
  end
end

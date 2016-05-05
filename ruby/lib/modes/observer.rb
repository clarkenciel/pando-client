module Modes
  class Observer
    attr_reader :messages
    
    def initialize(pando_server, room_name, chuck_port=5375)
      @server = pando_server
      @room_name = room_name
      @chuck = Chuck::Process.new("observer.ck", chuck_port)
      @messages = Common::PushOffList.new 20
      @users = []
      @socket = PandoSocket.connect(
        pando_server, room_name, 'observer',
        onopen = ->(response) do
          #puts "socket opened #{response}"
          (@users = users).each { |u| @chuck.send '/add_user', u['userName'], u['frequency'] }          
        end,
        onmessage = ->(message, type) do
          message = JSON.parse(message)          
          #puts message
          if message['type'] == 'message'
            if message['message'].include? 'has left'
              @chuck.send '/delete', message['leavingUser']
              @users.select! { |u| u['userName'] != message['leavingUser'] }
            elsif message['message'].include? 'has joined'              
              users.each do |u|
                unless @users.collect { |ui| ui['userName'] }.include? u['userName']
                  @chuck.send '/add_user', u['userName'], u['frequency']
                  @users.push u['userName']
                end
              end
            else
              @chuck.send '/update', message['userName'], message['frequency']
            end
            @messages.add({:user => message['userName'], :message => message['message']})
          end
        end,
        onerror = ->(*error) do
          puts "Socket error #{error}"
          stop
        end
      )
    end
    
    def stop
      @chuck && @chuck.kill
      @socket && @socket.cancel
    end
    
    def users
      uri = "http://#{@server}/pando/api/rooms/info/users/#{@room_name}"
      #puts uri
      JSON.parse(::Net::HTTP.get(URI(uri)))['users']
    end
  end
end

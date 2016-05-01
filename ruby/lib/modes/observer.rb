require 'json'
require 'net/http'

module Modes
  class Observer
    attr_reader :messages
    def initialize(pando_server, room_name, chuck_port=5375)
      @room_name = room_name
      @chuck = Chuck::Process.new("observer.ck", chuck_port)
      @messages = Common::PushOffList.new 20
      @socket = PandoSocket.connect(
        pando_server, room_name, 'observer',
        onopen = ->() {
          users.each { |u| @chuck.send '/add_user', u['userName'], u['frequency'] } },
        onmessage = ->(message) {
          if message['type'] == 'message'
            if message['message'].include? "has left"
              @chuck.send '/delete', message['leavingUser']
            else
              @chuck.send '/update', message['userName'], message['frequency']
            end
            @messages.add({:user => message['userName'], :message => message['message']})            
          end
        })
    end
    
    def stop
      @chuck.kill
      @socket.kill
    end
    
    def users
      uri = "http://clarkenciel.com/pando/api/rooms/info/users/#{@room_name}"
      JSON.parse(Net::HTTP.get(URI.new(uri)))
    end
  end
end

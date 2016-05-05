module Pando
  def self.http_type(const_sym, uri, body)
    ->(http) do
      type = Net::HTTP.const_get const_sym
      req = type.new uri.request_uri
      req.body = body.to_json
      req.content_type = 'application/json'
      http.request req
    end
  end
  
  # Return a closure that can be run in as a block in
  # Net::HTTP.start to get a resource at a given URI,
  # according to a given body (should be a hash)
  def self.get(uri, body)
    http_type :Get, uri, body
  end
  
  # Return a closure that can be run in as a block in
  # Net::HTTP.start to delete a resource at a given URI,
  # according to a given body (should be a hash)
  def self.delete(uri, body)
    http_type :Delete, uri, body
  end

  # Accepts a given server on which a pando instance is hosted
  # along with the name of a user to delete and the room in which
  # the user 'resides.'
  #
  # Then removes the user from the room
  def self.delete_user(server, room_name, user_name)
    uri = URI("https://#{server}/pando/api/quit")
    body = {'user-name' => user_name, 'room-name' => room_name}    
    Net::HTTP.start(uri.host, uri.port, &delete(uri, body))
  end

  def self.get_user_info(server, room_name, user_name)
    uri = URI("https://#{server}/pando/api/rooms/info/#{room_name}/#{user_name}")
    Net::HTTP.start(uri.host, uri.port,&get(uri, {}))
  end
end

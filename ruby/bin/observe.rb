require_relative '../lib/pando-client.rb'

#o = Modes::Observer.new 'clarkenciel.com', 'clarkenciel'
o = Modes::Observer.new 'localhost:10002', 'test'
v = Views::Message.new o

v.clear
while true do
  v.display
end

require_relative '../lib/pando-client.rb'

o = Modes::Observer.new 'clarkenciel.com', 'calarts'
#o = Modes::Observer.new 'localhost:10002', 'test'
#o = Modes::Observer.new 'localhost:10001', 'test'
v = Views::Message.new o

v.clear
while true do
  v.display
end

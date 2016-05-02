require_relative '../lib/pando-client.rb'

o = Modes::Observer.new 'clarkenciel.com', 'calarts'
v = Views::Message.new o

v.clear
while true do
  v.display
end

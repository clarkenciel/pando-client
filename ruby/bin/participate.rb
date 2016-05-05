require_relative '../lib/pando-client.rb'

# p = Modes::Participant.new 'localhost:10001', 'test', 'om'
p = Modes::Participant.new 'clarkenciel.com', 'calarts', 'om'

while true do
  p.send_message('test hello') if [true,false][rand(0..1)]    
  sleep 1
end


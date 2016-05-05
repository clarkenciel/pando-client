require_relative '../lib/pando-client.rb'

p = Modes::Participant.new 'localhost:10001', 'test', 'ruby'

sleep 1

p.send('test hello')
p.stop

require 'cgi'
require_relative '../lib/pando-client.rb'

# pando
p = Modes::Participant.new 'clarkenciel.com', 'calarts', 'om'

# oblique strategies
uri = URI('http://www.oblique-strategies.com')
h2_regexp = /.*<h2>(.*)<\/h2>/
tag_open_regexp = /<.*>/
tag_close_regexp = /<\/.*>/

# times
times = [5, 10, 20].map { |s| s * 60 }

while true do
  msg = CGI.unescapeHTML(Net::HTTP.get(uri).
                          match(h2_regexp)[1].
                          split(tag_open_regexp,2).
                          join)
  p.send_message(msg) if [true,false][rand(0..1)]
  sleep times[rand(0..times.size-1)]
end


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
  msg = nil
  begin
    msg = CGI.unescapeHTML(Net::HTTP.get(uri).
                          match(h2_regexp)[1].
                          split(tag_open_regexp,2).
                          join)
  rescue
    msg = 'I have no further advice for you'
  end
  p.send_message(msg)
  sleep(5 * 60)
end


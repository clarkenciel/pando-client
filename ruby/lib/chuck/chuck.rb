require 'ruby-osc'

module Chuck
  %w[ message process ].each { |f| require_relative f }
end

=begin
(1..10).each do |x|
  Thread.new do
    y = x
    while y > 0
      sleep y
      puts "Thread #{x}: #{y}"
      y -= 1
    end
  end
end
=end

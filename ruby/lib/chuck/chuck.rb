module Chuck
  %w[ message process ].each { |f| require_relative f }
end

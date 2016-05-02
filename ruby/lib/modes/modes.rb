
module Modes
  %w[
 common/pushofflist
 observer
 participant
 relay
 ].each { |f| require_relative f }
end

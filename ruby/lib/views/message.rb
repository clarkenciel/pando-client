module Views
  class Message
    def initialize(message_haver)
      @holder = message_haver
    end

    def display
      if @holder.messages.has_message?
        clear
        @holder.messages.contents.each do | message |
          puts "#{message[:user]}: #{message[:message]}"       
        end
      end
    end

    def clear
      Gem.win_platform? ? (system 'cls') : (system 'clear')
    end
  end
end

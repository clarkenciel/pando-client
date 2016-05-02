# a list that, when added to, removes the oldest values
# once longer than a certain size.

module Common
  class PushOffList    
    def initialize(max_size=10, *initial_vals)
      @max_size = max_size
      @contents = initial_vals
      @has_message
    end

    def add(*values)
      #puts values
      @has_message = true
      if @contents.size + values.size > @max_size
        dif = @contents.size + values.size - @max_size
        @contents.concat(values).shift(dif)
        @contents
      else
        @contents.concat values
      end
    end

    def contents
      @has_message = false
      @contents
    end

    def has_message?
      @has_message
    end      
  end
end

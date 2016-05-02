# a list that, when added to, removes the oldest values
# once longer than a certain size.

module Common
  class PushOffList
    attr_reader :contents
    def initialize(max_size=10, *initial_vals)
      @max_size = max_size
      @contents = initial_vals
    end

    def add(*values)
      puts values
      if @contents.size + values.size > @max_size
        dif = @contents.size + values.size - @max_size
        @contents.concat(values).shift(dif)
        @contents
      else
        @contents.concat values
      end
    end
  end
end

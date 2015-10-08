module Mastermind
  module Oscar
    class TimeManager
      attr_reader :start, :stop
      def start_timer
        @start = Time.now
      end

      def stop_timer
        @stop = Time.now
      end

      def get_time(secs = get_seconds)
        secs = secs.to_i
        days, secs = evaluate(secs, 86400)
        hour, secs = evaluate(secs, 3600)
        min, secs  = evaluate(secs, 60)

        string = []
        string << to_string(days, 'day')
        string << to_string(hour, 'hour')
        string << to_string(min, 'minute')
        string << to_string(secs, 'second')
        
        string.select!{|x| !x.nil?}
        string.join(", ")
      end

      def evaluate(x,y)
        [x / y, x % y] 
      end

      def get_seconds
        stop - start
      end

      def to_string(time, unit)
        return if time == 0

        time > 1 ? s = 's' : s = ''
        "#{time} #{unit}#{s}"
      end
    end
  end
end
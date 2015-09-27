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

      def get_time
        secs = get_seconds.to_i
        days = secs / 86400
        secs = secs % 86400
      end

      def evaluate(x,y)
        [x / y, x % y] 
      end


      def get_seconds
        @stop - @start
      end
    end
  end
end
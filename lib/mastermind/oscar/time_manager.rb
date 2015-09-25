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
        @stop - @start
      end
    end
  end
end
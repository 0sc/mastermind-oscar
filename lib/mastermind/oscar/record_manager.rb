module Mastermind
	module Oscar
		class RecordManager
      attr_reader :user
			
      def initialize(difficulty, stream = STDIN)
				@difficulty = difficulty
        set_read_stream(stream)
        set_user
			end

      def set_user
        puts "What's is your name?"
        @user = @stream.gets.chomp.capitalize
      end

      def set_read_stream (stream = STDIN)
        @stream = stream
      end
		end
	end
end
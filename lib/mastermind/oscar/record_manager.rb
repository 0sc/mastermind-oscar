module Mastermind
	module Oscar
		class RecordManager
      attr_reader :user
			
      def initalize(difficulty)
				@difficulty = difficulty
        set_read_stream
        set_user
			end

      def set_user
        puts "What's is you name?"
        @user = @stream.gets.chomp.capitalize
      end

      def set_read_stream (stream = STDIN)
        @stream = stream
      end
		end
	end
end
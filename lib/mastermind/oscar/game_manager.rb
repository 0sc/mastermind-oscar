require_relative "printer"
require_relative "codemaker"
require_relative "record_manager"

module Mastermind
	module Oscar
		class GameManager
      attr_reader :difficulty

      def initialize 
        set_read_stream
         @printer = Mastermind::Oscar::Printer.new
      end

      # useful for testing inputs
      def set_read_stream (stream = STDIN)
        @stream = stream
      end

      def start_game
        puts "Welcome to MASTERMIND"
        status = true

        while status
          @printer.format_input_query "Would you like to (p)lay, read the (i)nstructions, view (s)cores or (q)uit?"

          input = get_first_char
          if input == 'q'
            return
          elsif input == 's'
            # show scores
          elsif input == 'i'
            # show instructions
          elsif input == 'p'
            # play game
            status = game_on? play
          end
        end
      end

      def play
        set_difficulty if @difficulty.nil?
        recorder= Mastermind::Oscar::RecordManager.new(@difficulty)

        codemaker = Mastermind::Oscar::Codemaker.new(difficulty,@printer,recorder)
        return codemaker.init 
      end

      def get_first_char
        return @stream.gets.chomp[0].downcase
      end

      def set_difficulty
        @printer.format_input_query "Choose difficulty:\n(b)eginner\n(i)ntermediate\n(a)dvanced\n(Invalid input will default to beginner)"

        input = get_first_char
        if input == "a"
          @difficulty = :advanced
        elsif input == "i"
          @difficulty = :intermediate
        else
          @difficulty = :beginner
        end
      end

      def game_on? (arg)
        return false if arg == :quit

        show_top_10 if arg == :won
        return true
      end

      def show_top_10
        
      end

		end
	end
end
module Mastermind
	module Oscar
		class GameManager
      attr_reader :difficulty

      def initalize
        set_read_stream
      end

      # useful for testing inputs
      def set_read_stream (stream = STDIN)
        @stream = stream
      end

      def start_game
        puts "Welcome to MASTERMIND"
        quit = false
        while !quit
          puts "Would you like to (p)lay, read the (i)nstructions, view (s)cores or (q)uit?"
          input = get_first_char
          if input == 'q'
            return
          elsif input == 's'
            # show scores
          elsif input == 'i'
            # show instructions
          elsif input == 'p'
            # play game
            status = play
          end
        end
      end

      def play
        set_difficulty if @difficulty.nil?

        printer = Mastermind::Oscar::Printer.new
        recorder= Mastermind::Oscar::RecordManager.new(@difficulty)

        codemaker=MASTERMIND::Oscar::CodeMaker.new(printer,difficulty,recorder)
        game = codemaker.init 
      end

      def get_first_char
        return @stream.gets.chomp[0].downcase
      end

      def set_difficulty
        puts "Choose difficulty:\n(b)eginner ()\n(i)ntermediate\n(a)dvanced\n(Invalid input will default to beginner)"
        input = get_first_char
        if input == "a"
          @difficulty = :advanced
        elsif input == "i"
          @difficulty = :intermediate
        else
          @difficulty = :beginner
        end
      end

		end
	end
end
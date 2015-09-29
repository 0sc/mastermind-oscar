require_relative "printer"
require_relative "codemaker"
require_relative "record_manager"

module Mastermind
	module Oscar
		class GameManager
      attr_reader :difficulty

      def initialize 
        set_read_stream 
      end

      # useful for testing inputs
      def set_read_stream (stream = STDIN)
        @stream = stream
      end

      def start_game
        puts "Welcome to MASTERMIND"
        status = true

        while status
          Printer.format_input_query "Would you like to (p)lay, read the (i)nstructions, view (s)cores or (q)uit?"

          input = get_first_char
          if input == 'q'
            return
          elsif input == 's'
            show_records
          elsif input == 'i'
            show_instructions
          elsif input == 'p'
            # play game
            status = game_on? play
          end
        end

      end

      def play
        set_difficulty #if @difficulty.nil?
        @recorder= RecordManager.new(@user)
        @user = @recorder.user unless @user

        codemaker = Codemaker.new(difficulty, @recorder)
        return codemaker.init 
      end

      def get_first_char
        return @stream.gets.chomp[0].downcase
      end

      def set_difficulty
        Printer.format_input_query "Choose difficulty:\n(b)eginner\n(i)ntermediate\n(a)dvanced\n(Invalid input will default to beginner)"

        input = get_first_char
        @difficulty = Mastermind::Oscar.game_level(input)
      end

      def game_on? (arg)
        return false if arg == :quit

        #show_top_10 if arg == :won
        return true
      end

      def show_records
        Printer.output_file(RecordManager.get_records)
      end

      def show_instructions
        Printer.output(RecordManager.get_instructions)
      end

		end

    def self.game_level(input = nil)
      levels = Hash.new(:beginner)
      levels['a'] = :advanced
      levels['i'] = :intermediate
      levels['b'] = :beginner

      return levels if input.nil?

      levels[input]
    end
	end
end
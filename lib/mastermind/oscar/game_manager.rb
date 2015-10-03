require_relative "printer"
require_relative "codemaker"
require_relative "record_manager"
require_relative "time_manager"

module Mastermind
	module Oscar
		class GameManager
      attr_reader :difficulty, :user

      def initialize(diff = nil)
        @difficulty = diff
        set_read_stream 
      end

      # useful for testing inputs
      def set_read_stream (stream = STDIN)
        @stream = stream
      end

      def alert_invalid_input
        Printer.output "\tHmmm! You entry seems incorrect. Try again."
      end

      def start_game(stub_for_test=false)
        Printer.welcome_msg
        status = true

        while status
          Printer.format_input_query

          input = get_first_char
          if input == 'q'
            break
          elsif input == 't'
            show_top_10
            status = !stub_for_test
          elsif input == 'i'
            show_instructions
            status = !stub_for_test
          elsif input == "r"
            show_records
            status = !stub_for_test
          elsif input == 'p'
            # play game
            status = game_on? play
            @difficulty = nil
          else 
            alert_invalid_input
            status = !stub_for_test
          end
        end
        @user ||= ''
        Printer.quit_msg(user)
      end

      def play(allowed = true)
        return :quit unless set_difficulty 
        @recorder= RecordManager.new(user)
        @user = @recorder.user unless user

        codemaker = Codemaker.new(difficulty, @recorder)
        return codemaker.start if allowed
      end

      def get_first_char
        return (@stream.gets + " ").chomp[0].downcase.strip
      end

      def set_difficulty
        return true if difficulty
        Printer.level_select_msg
        input = get_first_char

        return false if input.eql? 'q'

        @difficulty = Mastermind::Oscar.game_level(input)
      end

      def game_on? (arg)
        return false if arg == :quit

        show_top_10(@difficulty) if arg == :won
        return true
      end

      def show_records
        Printer.output_file(RecordManager.get_records)
      end

      def show_instructions
        Printer.output(RecordManager.get_instructions)
      end

      def show_top_10 (level = nil)
        list = level.nil? ? Mastermind::Oscar.game_level.values : [level]
        
        t_obj = TimeManager.new

        list.each do |lvl|
          lvl = lvl.to_s
          rec = RecordManager.get_top_ten(lvl)
          Printer.output_top_ten(lvl,rec,t_obj)
        end

      end

		end

    def self.game_level(input = nil)
      levels = Hash.new(:beginner)
      levels['a'] = :expert
      levels['i'] = :intermediate
      levels['b'] = :beginner

      return levels if input.nil?

      levels[input]
    end
	end
end
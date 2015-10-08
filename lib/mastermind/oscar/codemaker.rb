require_relative "time_manager"

module Mastermind
  module Oscar
    class Codemaker
      attr_reader :code, :timer, :difficulty, :recorder, :guess
      def initialize(difficulty, recorder)
        @difficulty = difficulty
        @recorder   = recorder
      end
 
      def start
        generate_code
        @timer = TimeManager.new
        @recorder.open_save_file(difficulty)
        @recorder.print_to_file("Sequence: \t\t<#{code.join}>")
        @timer.start_timer
        init_message

        return game_play
      end

      def game_play
        max_guess  = 12
        @guess     = 0

        while !out_of_guess?(guess, max_guess) 
          input = get_input

          if quit?(input)
            return :quit
          elsif cheat?(input)
             cheat
             return
          elsif is_valid_input?(input)
            @guess += 1
            status = analyze_input(input)
            return congratulations if status
          end
          Printer.output("\t\t\nYou've taken #{guess} out of #{max_guess} guesses.\n")
          guess_again
        end

        #Some one that is out of guesses
        return game_over        
      end

      def get_input(stream = STDIN)
        input = stream.gets.chomp
        input = input.nil? ? " " : input.upcase.strip

        input
      end

      def analyze_input(input)
        @recorder.print_to_file("Guess #{guess}:\t\t#{input}")

        input = input.split("")
        return true if input == code

        exact = exact_match(code, input)
        partial = partial_match(code, input, exact)
        exact = exact.size
        
        give_guess_feedback(input, exact, partial)

        false
      end

      def exact_match(game_code, input)
        exact = []
        input.each_index do |index|
          exact << index if game_code[index] == input[index]
        end
        exact
      end

      def partial_match(game_code, input,exact)
        partials = [] + game_code
        exact.each{|elt| partials[elt] = nil}
        partial = 0

        input.each_with_index do |item, index|
          pIndex = partials.index(item)

          if(pIndex && !exact.include?(index))
            partial += 1
            partials[pIndex] = nil
          end
        end
        partial
      end

      def give_guess_feedback(input, exact, partial)
        feedback = "Hmmm! Your guess, " + Printer.colour_letters(input) + ", has #{exact + partial} of the correct elements with #{exact} in the correct positions."

        Printer.output(feedback)
      end

      def out_of_guess?(guess, max_guess)
        guess.eql? max_guess
      end

      def quit?(input)
        input[0].upcase == 'Q' if !input.empty?
      end

      def cheat?(input)
        input.upcase == 'C' && input.length == 1
      end

      def cheat
        Printer.show_cheat(color_code)
      end

      def generate_code
         @code = []
         specs = difficulties(difficulty)
         @possible_colours = specs[1]
         characters = specs[0]

         characters.times do
          index = rand(0...@possible_colours)
          @code << colors[index]
         end
      end

      def difficulties(key)
        #key => [characters, colors]
        specs = {
          :beginner => [4, 4], 
          :intermediate => [6, 5], 
          :expert => [8, 6]
        }
        specs[key]
      end

      def colors
        Printer.colors.keys
      end

      def init_message
        a = (difficulty == :beginner) ? 'a' : 'an'
        Printer.greet_user(@recorder.user, a, difficulty, code.size, create_color_string)
      end

      def create_color_string
        count = 0
        string = []
        Printer.colors.each do |key, colo|
          break if count == @possible_colours
          text = colo.to_s
          text.gsub!(text[0],"(#{text[0]})")
          string << Printer.colour_text(text, colo)
          count += 1
        end
        string[0...-1].join(", ") + ", and " + string.last
      end

      def is_valid_input?(input)
        length = code.size
        return true if input.length == length

        puts "\t" + Printer.colour_background("     !!!::: Oops! Your input is too short :::!!!", :red) if input.length < length
        puts "\t" + Printer.colour_background("     !!!::: Oops! Your input is too long :::!!!", :red) if input.length > length

        false
      end

      def congratulations
        @timer.stop_timer
        play_time = @timer.get_time
        congratulation_msg(play_time)
        save_game(play_time)

        :won
      end

      def congratulation_msg(play_time)
        Printer.congratulations(@recorder.user,color_code, guess, play_time)
      end

      def save_game(play_time)
        @recorder.print_to_file("Guessed the sequence in: #{play_time}")
        @recorder.check_for_top_ten(code.join, guess, @timer.get_seconds, difficulty.to_s)
        @recorder.close
      end

      def game_over
        @timer.stop_timer
        Printer.game_over(@recorder.user, color_code)
        @recorder.print_to_file("Game over! #{@timer.get_time}")
        @recorder.close

        :end
      end

      def color_code
        Printer.colour_letters(code.join)
      end

      def guess_again
        Printer.output "\t\t\tGuess again"
      end

    end
  end
end
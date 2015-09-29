require_relative "time_manager"

module Mastermind
  module Oscar
    class Codemaker
      attr_reader :code, :timer
      def initialize(difficulty, recorder)
        @difficulty = difficulty
        @recorder   = recorder
      end
 
      def init
        generate_code
        @timer = TimeManager.new
        @recorder.open_save_file(@difficulty)
        @recorder.print_to_file("Sequence: \t\t<#{code.join}>")
        @timer.start_timer
        init_message

        return game_play
      end

      def game_play
        max_guess  = 12
        @guess     = 0

        while !out_of_guess? max_guess 
          input = gets.chomp.upcase

          if quit?(input)
            return :quit
          elsif cheat?(input)
             cheat
          elsif is_valid_input?(input)
            @guess += 1
            status = analyze_input(input)
            return congratulations if status
          end
          Printer.output("You've taken #{@guess} out of #{max_guess} guesses.\n")
          guess_again
        end

        #Some one that is out of guesses
        return game_over        
      end

      def analyze_input(input)
        @recorder.print_to_file("Guess #{@guess}:\t\t#{input}")

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
        feedback = "Your guess, " + Printer.colour_letters(input) + ", has #{exact + partial} of the correct elements with #{exact} in the correct positions."

        Printer.output(feedback)
      end

      def out_of_guess?(max_guess)
        @guess.eql? max_guess
      end

      def quit?(input)
        input[0].upcase == 'Q'
      end

      def cheat?(input)
        input[0].upcase == 'C'
      end

      def cheat
        Printer.output(color_code)
      end

      def generate_code
         @code = []
         specs = difficulties(@difficulty)
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
          :advanced => [8, 6]
        }
        specs[key]
      end

      def colors
        Printer.colors.keys
      end

      def init_message
        a = (@difficulty == :beginner) ? 'a' : 'an'
        Printer.output("I have generated #{a} #{@difficulty} sequence with #{code.size} elements made up of:")
        Printer.output(create_color_string + ". Use (q)uit at any time to end the game.")
        Printer.format_input_query("what's your guess?")
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

        puts "Your input is too short" if input.length < length
        puts "Your input is too long" if input.length > length

        false
      end

      def congratulations
        @timer.stop_timer
        play_time = @timer.get_time
        Printer.output("Congratulations! You guessed the sequence '#{color_code}' in #{@guess} guesses over #{play_time}")
        @recorder.print_to_file("Guessed the sequence in: #{play_time}")
        @recorder.close
        
        :won
      end

      def game_over
        @timer.stop_timer
        Printer.output("Game over! You've used up all your guesses. The sequence is '#{color_code}'.")
        @recorder.print_to_file("Game over! #{@timer.get_time}")
        @recorder.close

        :end
      end

      def color_code
        Printer.colour_letters(@code.join)
      end

      def guess_again
        Printer.format_input_query "Guess again"
      end

    end
  end
end
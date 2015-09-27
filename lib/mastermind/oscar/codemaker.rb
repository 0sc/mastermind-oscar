require_relative "time_manager"

module Mastermind
  module Oscar
    class Codemaker
      attr_reader :code, :timer
      def initialize(difficulty, printer, recorder)
        @difficulty = difficulty
        @printer    = printer
        @recorder   = recorder
      end
 
      def init
        generate_code
        @timer = Mastermind::Oscar::TimeManager.new
        @timer.start_timer
        init_message

        #return game_play
      end

      def game_play
        max_guess  = 12
        @guess     = 0

        while !out_of_guess? max_guess 
          input = gets.chomp.downcase

          if quit?(input)
            return :quit
          elsif cheat?(input)
             cheat
          elsif is_valid_input?(input)
            @guess += 1
            status = analyze_input(input)
            return congratulations if status
          end
          @printer.output("You've taken #{@guess} out of #{max_guess} guesses.\n")
          guess_again
        end

        #Some one that is out of guesses
        return game_over        
      end

      def analyze_input(input)
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
        feedback = "Your guess, " + @printer.colour_letters(input) + ", has #{exact + partial} of the correct elements with #{exact} in the correct positions."

        @printer.output(feedback)
      end

      def out_of_guess?(max_guess)
        @guess.eql? max_guess
      end

      def quit?(input)
        input[0] == 'q'
      end

      def cheat?(input)
        input[0] == 'c'
      end

      def cheat
        @printer.output(color_code)
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
        @printer.colors.keys
      end

      def init_message
        a = (@difficulty == :beginner) ? 'a' : 'an'
        @printer.output("I have generated #{a} #{@difficulty} sequence with #{code.size} elements made up of:")
        @printer.output(create_color_string + ". Use (q)uit at any time to end the game.")
        @printer.format_input_query("what's your guess?")
      end

      def create_color_string
        count = 0
        string = []
        @printer.colors.each do |key, colo|
          break if count == @possible_colours
          text = colo.to_s
          text.gsub!(text[0],"(#{text[0]})")
          string << @printer.colour_text(text, colo)
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
        @printer.output("Congratulations! You guessed the sequence '#{color_code}' in #{@guess} guesses over #{} minutes, 22 seconds.")
        :won
      end

      def game_over
        @printer.output("Game over! You've used up all your guesses. The sequence is '#{color_code}'.")

        :end
      end

      def color_code
        @printer.colour_letters(@code.join)
      end

      def guess_again
        @printer.format_input_query "Guess again"
      end

    end
  end
end
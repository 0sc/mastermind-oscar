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
        @max_guess  = 12
        @guess      = 0;

        while @guess < @max_guess 
          input = gets.chomp.downcase

          return false if input[0] == 'q'

          if input[0] == 'c'
             @printer.output(@printer.colour_letters(code))
          elsif verify_input(input)
            @guess += 1
            status = analyze_input(input)
          end
        end
        
      end

      def analyze_input(input)
        return true if input == @code

        exact = 0
        partial  = 0

        input = input.split("")
        @code.each_with_index do |item, index|

        end
      end

      def generate_code
         @code = []
         specs = difficulties(@difficulty)
         @possible_colours = specs[1]
         @characters = specs[0]

         @characters.times do
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
        @printer.output("I have generated #{a} #{@difficulty} sequence with #{@characters} elements made up of:")
        @printer.output(create_color_string + ". Use (q)uit at any time to end the game.")
        @printer.output("what's your guess?")
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

      def verify_input(input)
        return true if input.length == 4

        puts "Your input is too short" if input.length < 4
        puts "Your input is too long" if input.length > 4

        false
      end
    end
  end
end
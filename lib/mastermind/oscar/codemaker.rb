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
      end

      def game_play

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
        @printer.output("I have a generated #{a} #{@difficulty} sequence with #{@characters} elements made up of:")
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

    end
  end
end
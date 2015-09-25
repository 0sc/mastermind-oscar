module Mastermind
  module Oscar
    class Codemaker
      attr_reader :code
      def initialize(difficulty, printer, recorder)
        @difficulty = difficulty
        @printer    = printer
        @recorder   = recorder
      end
 
      def init
        generate_code
      end

      def generate_code
         @code = []
         specs = difficulties(@difficulty)
         possible_colours = specs[1]
         characters = specs[0]

         characters.times do
          index = rand(0...possible_colours)
          @code << colors[index]
         end
      end

      def set_difficulty  

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
    end
  end
end
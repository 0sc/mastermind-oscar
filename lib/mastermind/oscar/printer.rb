require "colorize"

module Mastermind
  module Oscar
    class Printer
      attr_reader :stream
      def initialize
        set_output_stream
      end

      def output (content)
        @stream.puts content
      end

      def colors
        {
          "r" => :red,
          "g" => :green,
          "b" => :blue,
          "y" => :yellow,
          "c" => :cyan,
          "m" => :magenta
        }
      end

      def color_letters(word)
        word = word.split("").map!{ |letter| colour_text(letter,colors[letter]) }
        word.join
      end

      def colour_text (content, colour)
        content.colorize(:color => colour)
      end

      def colour_background (content, colour)
        content.colorize(:background => colour)
      end

      def colour_background_text (content, colour, b_colour)
        content.colorize(:background => b_colour).colorize(:color => colour)
      end

      def set_output_stream (stream = STDOUT)
        @stream = stream 
      end
    end
  end
end
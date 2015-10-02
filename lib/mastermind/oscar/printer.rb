require "colorize"

module Mastermind
  module Oscar
    class Printer
      @@stream = STDOUT
      def self.initialize
        set_output_stream
      end

      def self.output (content)
        @@stream.puts content
      end

      def self.stream
        @@stream
      end

      def self.colors
        {
          "R" => :red,
          "G" => :green,
          "B" => :blue,
          "Y" => :yellow,
          "C" => :cyan,
          "M" => :magenta
        }
      end

      def self.colour_letters(word)
        word = word.split("") unless word.is_a?(Array)

        word = word.map!{ |letter| colour_text(letter,colors[letter]) }
        word.join
      end

      def self.colour_text (content, colour)
        content.colorize(:color => colour)
      end

      def self.colour_background (content, colour)
        content.colorize(:background => colour)
      end

      def self.colour_background_text (content, colour, b_colour)
        content.colorize(:background => b_colour).colorize(:color => colour)
      end

      def self.set_output_stream (stream = STDOUT)
        @@stream = stream 
      end

      def self.format_input_query(text)
        @@stream.print "\n#{text}\n>\t"
      end

      def self.output_file(file)
        file.each do |f|
          f.each_line do |line|
            fColor = line.split("\t\t") 
            if fColor.size == 2
              fColor[-1] = colour_letters(fColor.last);
              line = fColor.join("\t\t")
            end
            print line
          end
          f.close
          puts "\n\n"
        end        
      end

      def self.output_top_ten(level, array,time_obj)
        puts level.upcase
        count = 1
        array.each do |entry|
          name = entry[:name]
          code = colour_letters(entry[:code])
          guess = entry[:guess]
          time = time_obj.get_time(entry[:time])
          output(top_score_display_text(count,name,code,guess,time))
          count += 1
        end
        puts ""
      end

      def self.top_score_display_text(count,name,code,guess,time)
        "#{count}. #{name} solved '#{code}' in #{guess} guesses over #{time}"
      end
    end
  end
end
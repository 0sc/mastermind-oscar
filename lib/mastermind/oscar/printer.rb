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

      def self.format_input_query
        output game_message
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
        puts "#{level.upcase}"
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

      def self.game_message
        mess = <<-EOS
        * Enter p to play
        * Enter i for instructions
        * Enter t for top scores
        * Enter r for records
        * Enter q to quit
      EOS
      end

      def self.welcome_msg
        output <<-EOS

          (  `                 )                                (
          )\))(      )      ( /(   (   (       )    (           )\ )
         ((_)()\  ( /(  (   )\()) ))\  )(     (     )\   (     (()/(
         (_()((_) )(_)) )\ (_))/ /((_)(()\    )\  '((_)  )\ )   ((_))
         |  \/  |((_)_ ((_)| |_ (_))   ((_) _((_))  (_) _(_/(   _| |
         | |\/| |/ _` |(_-<|  _|/ -_) | '_|| '  \() | || ' \))/ _` |
         |_|  |_|\__,_|/__/ \__|\___| |_|  |_|_|_|  |_||_||_| \__,_| "

         \n\t\t.::::::::::::::. WELCOME .:::::::::::::::.\n\n
        EOS
      end

      def self.level_select_msg
        output <<-EOS
        Select difficulty
        Enter b for beginner
        Enter i for intermediate
        Enter a for expert
        [invalid entry will default to beginner]
        EOS
      end

      def self.quit_msg(user)
        output <<-EOS
.:::::::::. Thank you for playing, #{user} .::::::::::.

+-+-+-+-+-+-+-+
|C|I|A|O|!|!|!|
+-+-+-+-+-+-+-+
EOS
      end

      def self.greet_user(user, a, diff, csize, colors)
        output <<-EOS
.:: Nice to meet you, #{user} ::.

Ok, I have generated a #{diff} sequence with #{csize} elements made of :
#{colors}
Enter (q)uit at any time to exit the game\n
CAN YOU GUESS THE SEQUENCE?
         EOS
      end

      def self.show_cheat(code)
        output <<-EOS
        The sequence is
        ========
        ||#{code}||
        ========
        EOS
        line
      end

      def self.line
        puts "-"*80 + "\n"
      end

      def self.game_over(user, color)
        output <<-EOS
      ____ ______  ______    _______ __________
      (( __||=||| \/ ||==    ((   ))\ //|==||_//
         \\_||| |||    ||___    \\_// \V/||__|| \\
You have used up all your guesses.
EOS
        show_cheat(color)
      end

      def self.congratulations(user,color,guess, time)
        output <<-EOS
        Congratulations!!! #{user}
        You guessed the sequence #{color} in #{guess} guesses over #{time}
        EOS
      end
    end
  end
end

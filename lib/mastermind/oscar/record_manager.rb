require "yaml"
module Mastermind
	module Oscar
		class RecordManager
      attr_reader :user
			
      def initialize(name = nil, stream = STDIN)
        set_read_stream(stream)
        name.nil? ? set_user : @user = name
			end
      
      def self.create_save_files
         if !Dir.exist?(file_path)
          Dir.mkdir(file_path)
          level = Mastermind::Oscar.game_level.values
          level.each do |lvl|
            File.open("#{file_path}top_ten_#{lvl}.yaml","w+")
            File.open("#{file_path}#{lvl}_record.txt", "w+")
          end
         end
      end
      
      def file_path
        RecordManager.file_path
      end

      def self.file_path
        # File.join(File.dirname(File.expand_path(__FILE__)), '../../../files/')
        "files/"
      end

      def set_user
        print <<-EOS
            \tAwesome!, you want to play. Let's begin!
            \tMy name is Mastermind; what's is yours?
            EOS
        @user = @stream.gets.chomp.capitalize
        @user = "Anonymous" if @user.empty?
      end

      def open_save_file(difficulty)
        @input_file = File.open(file_path+difficulty.to_s+"_record.txt", "a+")
        initalize_file
      end

      def set_read_stream (stream = STDIN)
        @stream = stream
      end

      def print_to_file (content)
        @input_file.puts content
      end

      def initalize_file
        text = "\nName:\t#{@user}\n"
        text += Time.now.strftime("%l:%M%P %b %d, %Y")
        print_to_file(text)
      end

      def close
        @input_file.close if @input_file
      end

      def check_for_top_ten(code, guess, time, difficulty)
        top_ten = self.class.get_top_ten(difficulty)
        position = is_hero?(top_ten, guess, time)

        position = top_ten.size if(!position && top_ten.size < 10)

        if position
          top_ten = insert_in_top_ten(prep_hash(code, guess, time), position, top_ten)
 
          save_top_ten(top_ten, difficulty)
          return position
        end
      end

      def save_top_ten(array,difficulty)
        file = self.class.get_heros_file(difficulty)
        serial = YAML::dump(array)
        File.open(file, "w+") {|f| f.puts serial}
      end

      def self.get_heros_file(difficulty)
        "#{file_path}top_ten_#{difficulty}.yaml"
      end

      def insert_in_top_ten(hero, position, array)
        new_arr = []
        i = 0
        shift = false
        limit  = array.size
        limit = (limit >= 10) ? limit : limit + 1
        
        limit.times do
          if i == position
            new_arr << hero
            shift = true
          else
            index = shift ? i - 1 : i
            new_arr << array[index]
          end
          i += 1
        end

        new_arr
      end

      def prep_hash(code, guess, time)
        {
          name: user,
          code: code,
          guess: guess,
          time: time
        }
      end

      def self.get_records
        #levels = []
        #if difficulty
         # levels << difficulty
        #else
          levels = Mastermind::Oscar.game_level
          levels = levels.values
        #end
        
        files = []
        levels.each do |level|
          files << File.open("files/"+level.to_s+"_record.txt", "r+")
        end          
        files
      end

      def self.get_instructions
        msg = <<-EOS
          Playing Mastermind is pretty easy.

##Rules

* Once the game starts, you have the option to either play, view instructions, view top ten scores or view score records
* To play the game, enter p
* To view instructions, enter i
* To view top ten scores, enter t
* To view score records, enter s
* Once you enter p to play, your are given the option to select a difficulty level; beginner, intermediate or expert. The level default to beginner for invalid choice.
* You will be required to enter you name to aid in recording your score
* Computer will generate a set of random characters made of colours. The lenght of the characters generated and the colours used depends on the game level.
* For beginners, 4 characters consisting of red, blue, green and/or yellow. e.g. rbgy
* For intermediate, 6 characters consisting of red, blue, green, yellow and/or cyan e.g. rrbyc
* For expert, 8 characters consisting of red, blue, green, yellow, cyan and magenta e.g. bgrrgm
* Note that colours can be repeated in the sequence
* You are to guess the sequence by inputing the combination.
* You will be given helpful feedback on each guess you make. Study the feedback to know the colours you were able to guess and their right position in the sequence.
* After 12 unsuccessful attempts, the game is over and you lost
* You can stop the game at any time by inputing q

Have fun
        EOS
      end

      def self.get_top_ten (difficulty)
        file = get_heros_file(difficulty)
        content = []
        File.open(file, "r+") do |val| 
          content = YAML::load(val)
        end
        content = [] if !content
        content
      end

      def is_hero?(heros, guess, time)
        return unless heros.is_a?(Array)
        guess = guess.to_i
        heros.each_with_index do |hero, index|
          hero[:guess] = hero[:guess].to_i
          if hero[:guess].to_i > guess
            return index
          elsif hero[:guess] == guess
            return index if hero[:time] >time            
          end
        end
        nil
      end

		end
	end
end
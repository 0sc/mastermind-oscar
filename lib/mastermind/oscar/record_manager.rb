require "yaml"
module Mastermind
	module Oscar
		class RecordManager
      attr_reader :user
			
      def initialize(user = '', stream = STDIN)
        set_read_stream(stream)
        @user = user if user
        set_user unless user
        Dir.mkdir("files") unless Dir.exist?("files")
			end

      def file_path
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
        "files/top_ten_#{difficulty}.yaml"
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
        iFile = File.open("files/instructions.txt", "r+")
        text = ''
        iFile.each_line do |line|
          text += line
        end
        text
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
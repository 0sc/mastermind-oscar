module Mastermind
	module Oscar
		class RecordManager
      attr_reader :user
			
      def initialize(user = '', stream = STDIN)
        set_read_stream(stream)
        @user = user if user
        set_user unless user
			end

      def file_path
        "files/"
      end

      def set_user
        print "Awesome!, you want to play. Let's begin!\nMy name is Mastermind; What's is yours?\n>\t"
        @user = @stream.gets.chomp.capitalize
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
          files << File.open("files/"+level.to_s+"_record.txt", "r")
        end          
        files
      end

      def self.get_instructions
        iFile = File.open("files/instructions.txt", "r")
        text = ''
        iFile.each_line do |line|
          text += line
        end
        text
      end

		end
	end
end
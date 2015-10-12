require 'test_helper'

class RecordManagerTest < Minitest::Test
  def setup
    FakeFS.activate!
    FileUtils.mkdir_p('/tmp')

    @record_class = Mastermind::Oscar::RecordManager
    @client = @record_class.new(nil, StringIO.new("Adebayo\n"))
    @record_class.create_save_files
    @game_level = Mastermind::Oscar.game_level.values
  end

  def teardown
    FakeFS.deactivate!
  end

  def test_initialize
    assert_equal(@client.user, "Adebayo")
  end

  def test_object
    assert_instance_of @record_class, @client
  end

  def test_methods
    mtds = :file_path, :set_user, :open_save_file, :set_read_stream, :print_to_file, :initalize_file, :close, :check_for_top_ten, :save_top_ten, :insert_in_top_ten, :prep_hash, :is_hero?

    mtds.each do |mtd|
      assert_respond_to @client, mtd
    end
  end

  def test_create_save_files
    game_files = []
    @game_level.each do |lvl|
      game_files << "#{@client.file_path}top_ten_#{lvl}.yaml"
      game_files << "#{@client.file_path}#{lvl}_record.txt"
    end
    assert File.exist? @client.file_path
    assert_equal(@game_level, @record_class.create_save_files)
    game_files.each do |file|
      assert File.exist? file
      assert File.readable? file
      assert File.writable? file
    end
  end

  def test_set_user
  	@client.set_read_stream(StringIO.new("Oscar\n"))
  	@client.set_user
  	assert_equal("Oscar", @client.user)
  end

  def test_file_path
    assert_equal @record_class.file_path, @client.file_path
    assert File.exist? @record_class.file_path
  end

  def test_class_file_path
    assert @record_class.file_path
    assert File.exist? @record_class.file_path
  end

  def test_open_save_file
    assert_raises(ArgumentError) {@client.open_save_file}
    @client.stub(:initalize_file, "") do
      @game_level.each do |lvl|
        @client.open_save_file("lvl")
        assert_kind_of FakeFS::File, @client.input_file
        assert File.writable? @client.input_file
      end
    end
  end

  def test_set_read_stream
    assert_equal STDIN, @client.set_read_stream
    assert_equal "stream", @client.set_read_stream("stream")
  end

  def test_print_to_file
    assert_raises(ArgumentError) {@client.print_to_file}
    path = "file.txt"
    file = File.open(path, 'w+')
    @client.stub(:input_file, file) do
      @client.print_to_file("Yada Yada")
      content = File.read(path).chomp
      assert_equal "Yada Yada", content
    end
  end

  def test_initalize_file
    @client.stub(:print_to_file, nil) do
      assert_nil @client.initalize_file
    end
  end

  def test_close
    assert_nil @client.close
    path = "file.txt"
    file = File.open(path, "w")
    file.write "Yada"
    @client.stub(:input_file, file) do
      @client.close
      assert_raises IOError do
        file.read
      end
    end
  end

  def test_check_for_top_ten
    assert_raises(ArgumentError) {@client.check_for_top_ten}
    file = :testing

    @record_class.stub(:get_top_ten, []) do
      @client.stub(:is_hero?, nil) do
        assert_equal 0, @client.check_for_top_ten("rrrr", 12, 50, file)
      end

      @client.stub(:is_hero?, 4) do
        assert_equal 4, @client.check_for_top_ten("rrrr", 12, 50, file)
      end
    end

    data = Array.new
    10.times { data << {name: "Name", code: "code", guess: 40, time: 45} }

    @record_class.stub(:get_top_ten, data) do
      @client.stub(:is_hero?, nil) do
        assert_nil @client.check_for_top_ten("rrrr", 12, 50, file)
      end
      @client.stub(:is_hero?, 4) do
        assert_equal 4, @client.check_for_top_ten("rrrr", 12, 50, file)
      end
      assert_equal 0, @client.check_for_top_ten("rrrr", 12, 50, file)
    end
  end

  def test_save_top_ten
    refute @client.save_top_ten([],:beginner)
  end

  def test_get_heros_file
    input = %w[beginner expert intermediate hello come]
    path  = @record_class.file_path
    input.each do |i|
      assert_equal "#{path}top_ten_#{i}.yaml", @record_class.get_heros_file(i)
    end
    assert @record_class.get_heros_file("")
  end

  def test_insert_in_top_ten
    assert_equal [nil], @client.insert_in_top_ten("", "",[])
    assert_equal [5]+(1..9).to_a, @client.insert_in_top_ten(5,0,(1..10).to_a)
    assert_equal [5]+(1..9).to_a, @client.insert_in_top_ten(5,0,(1..9).to_a)
  end

  def test_prep_hash
    exp = {name: "Adebayo", code: "code", guess: "guess", time: "time"}

    assert_equal exp, @client.prep_hash(exp[:code], exp[:guess], exp[:time])
  end

  def test_get_records
    path = "file"
    File.open("files/file_record.txt", "w+") {|f| f.puts "Yada Yada Yada"}
    Mastermind::Oscar.stub(:game_level, x: path) do
      record = @client.class.get_records.first
      assert_kind_of FakeFS::File, record
      record.each_line do |line|
        assert_equal "Yada Yada Yada", line.chomp
      end
    end

  end

  def test_get_instructions
    assert @client.class.get_instructions
  end

  def test_get_top_ten
    lvl = "test"
    path= "files/top_ten_#{lvl}.yaml"
    File.open(path, "w+")
    assert_equal [], @record_class.get_top_ten(lvl)
    data = [{name: "Name", code: "code", guess: 40, time: 45}]
    File.open(path,"w") do |f|
      YAML.dump(data, f)
    end
    assert_equal data, @record_class.get_top_ten(lvl)
  end

  def test_is_hero?
    assert_nil @client.is_hero?("","", "")
    list = [{guess: 6, time: 30}]
    assert_equal 0, @client.is_hero?(list, 5, 20)
    assert_equal 0, @client.is_hero?(list, 6, 20)
    assert_nil @client.is_hero?(list,6,50)
  end

end

require 'test_helper'
require "mastermind/oscar/record_manager"
require "mastermind/oscar/game_manager"
require "stringio"

class RecordManagerTest < Minitest::Test
  def setup
    @client = Mastermind::Oscar::RecordManager.new(nil, StringIO.new("Adebayo\n"))
  end

  def test_initialize
    assert_equal(@client.user, "Adebayo")
  end

  def test_object
    assert_instance_of Mastermind::Oscar::RecordManager, @client
  end

  def test_methods
    mtds = :file_path, :set_user, :open_save_file, :set_read_stream, :print_to_file, :initalize_file, :close, :check_for_top_ten, :save_top_ten, :insert_in_top_ten, :prep_hash, :is_hero?

    mtds.each do |mtd|
      assert_respond_to @client, mtd
    end
  end

  def test_set_user
  	@client.set_read_stream(StringIO.new("Oscar\n"))
  	@client.set_user
  	assert_equal("Oscar", @client.user)
  end

  def test_file_path
    assert_equal "files/", @client.file_path
  end

  def test_open_save_file
    assert_raises(ArgumentError) {@client.open_save_file}
  end

  def test_set_read_stream
    assert_equal STDIN, @client.set_read_stream
  end

  def test_print_to_file
    assert_raises(ArgumentError) {@client.print_to_file}
  end

  def test_initalize_file
    @client.stub(:print_to_file, nil) do 
      assert_nil @client.initalize_file
    end
  end

  def test_close
    assert_nil @client.close
  end

  def test_check_for_top_ten
    assert_raises(ArgumentError) {@client.check_for_top_ten}

    @client.stub(:is_hero?, false) do
      assert @client.check_for_top_ten("rrrr", 12, 50, :beginner)
    end
  end

  def test_save_top_ten
    refute @client.save_top_ten([],:beginner)
  end

  def test_get_heros_file
    input = %w[beginner, expert, intermediate, hello, come]
    input.each do |i|
      assert_equal "files/top_ten_#{i}.yaml", Mastermind::Oscar::RecordManager.get_heros_file(i)
    end
  end

  def test_insert_in_top_ten
    assert_equal [nil], @client.insert_in_top_ten("", "",[])

    assert_equal [5]+(1..9).to_a, @client.insert_in_top_ten(5,0,(1..10).to_a)
  end

  def test_prep_hash
    exp = {name: "Adebayo", code: "code", guess: "guess", time: "time"}

    assert_equal exp, @client.prep_hash(exp[:code], exp[:guess], exp[:time])
  end

  def test_get_records
    object = Mastermind::Oscar
    assert @client.class.get_records
  end

  def test_get_instructions
    assert @client.class.get_instructions
  end

  def test_get_top_ten
    assert @client.class.get_top_ten("beginner")
  end

  def test_is_hero?
    assert_nil @client.is_hero?("","", "")
    list = [{guess: 6, time: 30}]
    assert_equal 0, @client.is_hero?(list, 5, 20)
    assert_equal 0, @client.is_hero?(list, 6, 20)
    assert_nil @client.is_hero?(list,6,50)
  end

end
require 'test_helper'
require "mastermind/oscar/game_manager"
require "mastermind/oscar/record_manager"
require "stringio"

class GameManagerTest < Minitest::Test
  def setup
    @game = Mastermind::Oscar::GameManager.new
  end

  def check_difficulty (input, expectation)
  	input.each do |entry| 
  		@game.set_read_stream(StringIO.new("#{entry}\n"))
  		@game.set_difficulty
  		assert_equal(expectation, @game.difficulty)
  	end
  end

  def test_object
    assert_instance_of Mastermind::Oscar::GameManager, @game
  end

  def test_methods
    mtds = :set_read_stream, :alert_invalid_input, :start_game, :play, :get_first_char, :set_difficulty, :game_on?, :show_records, :show_instructions, :show_top_10, :difficulty
    mtds.each do |mtd|
      assert_respond_to @game, mtd, "Doesn't respond to #{mtd}"
    end
  end

  def test_start_game
    @game.stub(:get_first_char, 'q') do 
      assert_nil @game.start_game
    end

    %w[t i r].each do |i|
      @game.stub(:get_first_char, i) do 
        assert_nil @game.start_game(true)
      end
    end

    @game.stub(:get_first_char, 'p') do 
      @game.stub(:play, :quit) do 
        assert_nil @game.start_game
      end
    end
  end

  def test_get_first_char
    input = ['car', 'kram', 'stop', 'quit', 'start', 'play', ' boy', nil, '', '    ']
    exp   = ['c','k','s','q','s','p',"","","",""]
    input.each_with_index do |entry, i|
      @game.set_read_stream(StringIO.new("#{entry}\n"))
      assert_equal exp[i], @game.get_first_char
    end
  end

  def test_show_top_10
    lvls = :expert, :intermediate, :beginner
    lvls.each do |lvl|
      assert_equal([lvl], @game.show_top_10(lvl))
    end

    assert_equal lvls, @game.show_top_10
  end

  def test_set_read_stream
    assert_equal "cOW", @game.set_read_stream("cOW")
    assert_equal STDIN, @game.set_read_stream
  end

  def test_alert_invalid_input
    assert_nil @game.alert_invalid_input
  end

  def test_set_diffculty_expert
  	entries = %w{a ada active add Adv after ad}
  	check_difficulty(entries,:expert)
  end

  def test_set_diffculty_intermediate
  	entries = %w{intermediate inter i iron Iroko}
  	check_difficulty(entries,:intermediate)
  end

  def test_set_diffculty_random
  	entries = %w{zsdaf taee beginner 1232243 4546 3mau mountain}
  	check_difficulty(entries,:beginner)
  end

  def test_game_on
    refute @game.game_on?(:quit)

    values = ['asds', 'bs', :start, 232]
    values.each{|val| assert @game.game_on?(val)}

    @game.stub(:show_top_10, "") do 
      assert @game.game_on? :won
    end   
  end

  def test_play
  	@game.stub(:set_difficulty, false) do 
      assert_equal :quit, @game.play
    end

    @game.stub(:set_difficulty, :beginner) do 
      @game.stub(:user, "name") do 
        refute @game.play(false)
      end
    end
  end

  def test_won

  end

  def test_show_instruction
    @game.stub(:show_instructions, 'War and Peace') do
        assert_equal 'War and Peace', @game.show_instructions
      end
      assert_nil @game.show_instructions
  end

  def test_show_records
    refute_nil @game.show_records
  end

  def test_game_level
    input = 'a', 'b', 'i'
    exp = :expert, :beginner, :intermediate
    exp << exp 
    input.each_with_index do |entry, i|
      assert_equal exp[i], Mastermind::Oscar.game_level(entry)
    end
  end
end


module Mastermind
  module Oscar
    class RecordManager
      def open_save_file(difficulty)
        @input_file = File.open("files/test_record.txt","a+")
      end
    end
  end
end
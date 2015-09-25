require 'minitest/autorun'
require 'minitest/reporters'
require "mastermind/oscar/game_manager"
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

  def test_set_diffculty_advanced
  	entries = %w{advanced a ada active add Adv after ad}
  	check_difficulty(entries,:advanced)
  end

  def test_set_diffculty_intermediate
  	entries = %w{intermediate inter i iron Iroko}
  	check_difficulty(entries,:intermediate)
  end

  def test_set_diffculty_random
  	entries = %w{zsdaf taee beginner 1232243 4546 3mau mountain}
  	check_difficulty(entries,:beginner)
  end

  def test_start

  end

  def test_play
  	
  end

  def test_replay

  end

  def test_won

  end

  def show_instruction

  end
end
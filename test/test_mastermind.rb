require 'test_helper'
require "mastermind/oscar"

class MasterMindTest < Minitest::Test
  def setup
    @client = Mastermind::Oscar
  end

  def test_game_level_without_argument
    expect = {
      'b' => :beginner, 
      'a' => :advanced, 
      'i' => :intermediate
    }
    assert_equal(@client.game_level, expect)
  end

  def test_game_level_with_valid_argument
    args = %w/a b i/
    expect = %w/advanced beginner intermediate/

    args.each_with_index do |arg, index|
      assert_equal(@client.game_level[arg].to_s, expect[index])
    end
  end

  def test_game_level_with_invalid_argument
    args = %w/m xx yo ZC Q/
    expect = :beginner

    args.each do |arg|
      assert_equal(@client.game_level[arg], expect)
    end
  end
end
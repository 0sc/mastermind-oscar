require 'minitest/autorun'
require 'minitest/reporters'
require "mastermind/oscar/codemaker"
require "mastermind/oscar/printer"
require "mastermind/oscar/record_manager"
require "mastermind/oscar/time_manager"
require "stringio"

class CodemakerTest < Minitest::Test
  def setup
    difficulty  = :beginner
    printer     = Mastermind::Oscar::Printer.new
    recorder    = Mastermind::Oscar::RecordManager.new(difficulty,StringIO.new("Jeff\n"))
    @client     = Mastermind::Oscar::Codemaker.new(difficulty,printer,recorder)
  end

  def test_generate_code
    @client.generate_code
    assert_equal(4, @client.code.length)
    assert !@client.code.include?("m")

    timer_test
    init_message_test
  end

  def timer_test
    @client.init
    assert_instance_of(Mastermind::Oscar::TimeManager, @client.timer)
  end

  def init_message_test
    @client.init_message
  end

  def test_valid_input
    input = %w{rrrr rgbb}
    input.each do |i|
      assert @client.verify_input i
    end
  end

  def test_invalid_input
    input = %w{t k l o j e} << "a"*5 
    input.each do |i|
      assert !@client.verify_input(i)
    end
  end

end
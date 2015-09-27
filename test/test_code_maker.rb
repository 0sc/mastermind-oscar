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
    @printer     = Mastermind::Oscar::Printer.new
    recorder    = Mastermind::Oscar::RecordManager.new(difficulty,StringIO.new("Jeff\n"))
    @client     = Mastermind::Oscar::Codemaker.new(difficulty,@printer,recorder)
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
    input.each {|i| assert @client.is_valid_input?(i)}
  end

  def test_invalid_input
    input = %w{t k l o j e} << "a"*5 
    input.each {|i| assert !@client.is_valid_input?(i)}
  end

  def test_valid_quit
    input = %w{q quit quiet quays queen}
    input.each {|i| assert @client.quit?(i)}
  end

  def test_invalid_quit
    input = ('a'..'z').to_a
    input.delete('q')
    input.each {|i| assert !@client.quit?(i)}
  end

  def test_valid_cheat
    input = %w{c cheat chair change call come}
    input.each {|i| assert @client.cheat?(i)}

  end

  def test_invalid_cheat
    input = ('a'..'z').to_a
    input.delete('c')
    input.each {|i| assert !@client.cheat?(i)}
  end

  def test_exact_match
    code = [] ;input = []; expect= []

    code  << %w{r r g g} << %w{r r g g} << %w{r r g g}  << %w{g r r b} << %w{r b g y} << %w{y y y y}  << %w{b b g r}

    input << %w{r r r r}  << %w{g r r g} << %w{y y g g} << %w{b g g r} << %w{i j k l} << %w{y y v y} << %w{b b g r}

    expect << [0,1]  << [1,3] << [2,3] << [] << [] << [0,1,3] << [0,1,2,3]

    code.each_with_index do |arr, index|
      assert_equal(expect[index], @client.exact_match(arr, input[index]))
    end

  end

  def test_partial_match
    code = []; input = []; exact = []; partial = []

    code  << %w{r r g g} << %w{r r g g} << %w{r r g g}  << %w{g r r b} << %w{r b g y} << %w{y y y y}  << %w{b b g r}

    input << %w{r r r r}  << %w{g r r g} << %w{y y g g} << %w{b g g r} << %w{i j k l} << %w{y y v y} << %w{b b g r}

    exact << [0,1]  << [1,3] << [2,3] << [] << [] << [0,1,3] << [0,1,2,3]

    partial << 0 << 2 << 0 << 3 << 0 << 0 << 0

    code.each_with_index do |arr, index|
      assert_equal(partial[index], @client.partial_match(arr, input[index], exact[index]))
    end
  end

end
require 'test_helper'
require 'minitest/autorun'
require 'minitest/reporters'
require "mastermind/oscar/codemaker"
require "mastermind/oscar/time_manager"
require "stringio"

class CodemakerTest < Minitest::Test
  def setup
    difficulty  = :beginner
    @recorder   = Mastermind::Oscar::RecordManager.new(StringIO.new("Jeff\n"))
    @client     = Mastermind::Oscar::Codemaker.new(difficulty,@recorder)
  end

   def test_generate_code
     diff = [:beginner, :intermediate, :advanced]
     code_length = 4, 6, 8
     diff.each_with_index do |lvl, i|
        client   = Mastermind::Oscar::Codemaker.new(lvl,@recorder)
        client.generate_code
        assert_equal(code_length[i], client.code.length)
     end
  #   invalid_input_test
   end

  def test_init_message
    @client.stub(:code, "") do
      @client.init_message
    end
  end

  def test_valid_input
    input = %w{RRRR RGBB}
    @client.stub(:code, "RBGY") do 
      input.each {|i| assert @client.is_valid_input?(i)}
    end
  end

  def test_invalid_input
    input = %w{T K L O J E} << "A"*5 
     @client.stub(:code, "RBGY") do 
      input.each {|i| refute @client.is_valid_input?(i)}
    end
  end

  def test_valid_quit
    input = %w{Q QUIT QUIET QUAYS QUEEN}
    input.each {|i| assert @client.quit?(i)}
  end

  def test_invalid_quit
    input = ('a'..'z').to_a
    input.delete('q')
    input.each {|i| refute @client.quit?(i)}
  end

  def test_valid_cheat
    input = %w{c cheat chair change call come}
    input.each {|i| assert @client.cheat?(i)}

  end

  def test_invalid_cheat
    input = ('a'..'z').to_a
    input.delete('c')
    input.each {|i| refute @client.cheat?(i)}
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

  def test_difficulties
    diff = [:beginner, :intermediate, :advanced]
    values=[4,4],[6,5],[8,6]
    diff.each_with_index do |d, i|
      assert_equal(values[i], @client.difficulties(d))
    end
  end
end
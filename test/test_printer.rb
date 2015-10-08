require 'test_helper'

class PrinterTest < Minitest::Test
  attr_reader :colors
  def setup
    @client = Mastermind::Oscar::Printer
    @client.set_output_stream(StringIO.new)
    @text = "RGBYRCGM"
  end

  def colors
    [:red, :green, :blue, :yellow, :cyan, :magenta]
  end

  def test_object
    assert_instance_of Class, @client
  end

  def test_methods
    mtds = :stream, :colors, :colour_letters, :colour_text, :colour_background, :colour_background_text, :set_output_stream, :format_input_query, :output_file, :output_top_ten, :top_score_display_text

    mtds.each do |mtd|
      assert_respond_to @client, mtd
    end
  end

  def get_output(input)
    @client.output(input)
    @client.stream.string.chomp
  end

  def test_stream
    refute_nil @client.stream
  end

  def test_output
  	assert_equal(@text, get_output(@text))

    assert_nil @client.output("hello")
  end

  def test_colour_text
    colors.each do |colour|
      assert_equal(
        @text.colorize(:color => colour),
        get_output(@client.colour_text(@text, colour))
        )
      @client.stream.rewind
    end
  end

  def test_colour_background
    colors.each do |colour|
      assert_equal(
        @text.colorize(:background => colour),
        get_output(@client.colour_background(@text, colour))
        )
      @client.stream.rewind
    end
  end

  def test_colour_background_text
    colors.each do |colour|
      assert_equal(
        @text.colorize(:background => colour, :color => colour),
        get_output(@client.colour_background_text(@text, colour,colour))
        )
      @client.stream.rewind
    end
  end

  def test_colour_letters
    output = @text.split("").map {|x| @client.colour_text(x,@client.colors[x])}
    assert_equal(output.join, @client.colour_letters(@text))
  end

  def test_format_input_query
    assert_nil @client.format_input_query
  end

  def test_colours
    assert @client.colors
    hash = {
          "R" => :red,
          "G" => :green,
          "B" => :blue,
          "Y" => :yellow,
          "C" => :cyan,
          "M" => :magenta
        }

    hash.each do |key, val|
      assert_equal @client.colors[key], val
    end
  end

  def test_set_output_stream
    assert_equal STDOUT, @client.set_output_stream

    %w[hello work come go].each do |i|
      assert_equal i, @client.set_output_stream(i)
    end
  end

  def test_output_file
    file = [StringIO.new("Boss\nHello\n")]
    assert_equal file, @client.output_file(file)
  end

  def test_output_top_ten
    input = [{name: 'name', code: "rrrr", guess: 5, time: 60}]
    assert_nil @client.output_top_ten("", input, Mastermind::Oscar::TimeManager.new)
  end

  def test_top_score_display_text
    refute_nil @client.top_score_display_text("","","","","")
  end 

  def test_game_message
    assert @client.game_message
  end

  def test_welcome_msg
    assert_nil @client.welcome_msg
  end

  def test_level_select_msg
    assert_nil @client.level_select_msg
  end

  def test_quit_msg
    assert_nil @client.quit_msg(" ")
  end

  def test_greet_user
    assert_nil @client.greet_user(" "," "," "," "," ")
  end

  def test_show_cheat
    assert_nil @client.show_cheat("")
  end

  def test_line
    assert_nil @client.line
  end

  def test_game_over
    assert_nil @client.game_over("", "")
  end

  def test_congratulations
    assert_nil @client.congratulations("", "","","")
  end
end
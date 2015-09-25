require 'minitest/autorun'
require 'minitest/reporters'
require "mastermind/oscar/printer"
require "stringio"

class PrinterTest < Minitest::Test
  attr_reader :colors
  def setup
    @client = Mastermind::Oscar::Printer.new
    @client.set_output_stream(StringIO.new)
    @text = "busboy"
  end

  def colors
    [:red, :green, :blue, :yellow, :cyan, :magenta]
  end

  def get_output(input)
    @client.output(input)
    @client.stream.string.chomp
  end

  def test_output
  	assert_equal(@text, get_output(@text))
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

  def test_color_letters
    output = @text.split("").map {|x| @client.colour_text(x,@client.colors[x])}
    assert_equal(output.join, @client.color_letters(@text))
  end


end
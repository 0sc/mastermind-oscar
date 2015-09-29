require 'test_helper'
require 'minitest/autorun'
require 'minitest/reporters'
require "mastermind/oscar/printer"
require "stringio"

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
    assert_equal(output.join, @client.colour_letters(@text))
  end

  def test_format_input
    text = "Mastermind"
    @client.format_input_query(text)
    assert_equal("\n#{text}\n>\t", @client.stream.string)
  end

end
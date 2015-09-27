require 'minitest/autorun'
require 'minitest/reporters'
require "mastermind/oscar/time_manager"
require "time"

class TimeManagerTest < Minitest::Test
  def setup
   @client = Mastermind::Oscar::TimeManager.new
  end

  def test_start_timer
    @client.start_timer
    assert_in_delta(Time.now, @client.start)
  end

  def test_stop_timer
    @client.stop_timer
    assert_in_delta(Time.now, @client.stop)
  end

  def test_evaluate
    x = 18290, 290 
    y = 3600, 60
    ans = [5, 290], [4, 50]

    x.each_index do |i|
      assert_equal(ans[i], @client.evaluate(x[i], y[i]))
    end
  end

  def test_to_string
    input = [[1, 'hour'],[5, 'minute'],[0, 'second'],[1, 'second'],[6, 'hour']]
    expect = ['1 hour ', '5 minutes ', nil, '1 second ', '6 hours ']

    input.each_index do |i|
      time = input[i][0]
      unit = input[i][1]
      assert_equal(expect[i], @client.to_string(time, unit))
    end
  end


end
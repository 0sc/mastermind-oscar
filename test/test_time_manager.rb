require 'minitest/autorun'
require 'minitest/reporters'
require "mastermind/oscar/time_manager"

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
    y =  3600, 60
    ans = [5, 290], [4, 50]

    x.each_index do |i|
      assert_equal(ans[i], @client.evaluate(x[i], y[i]))
    end
  end
end
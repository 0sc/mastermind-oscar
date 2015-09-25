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

  def test_start_timer
    @client.stop_timer
    assert_in_delta(Time.now, @client.stop)
  end
end
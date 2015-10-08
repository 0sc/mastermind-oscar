require 'test_helper'

class TimeManagerTest < Minitest::Test
  def setup
   @client = Mastermind::Oscar::TimeManager.new
  end

  def test_object
    assert_instance_of(Mastermind::Oscar::TimeManager, @client)
  end

  def test_methods
    mtds = :get_seconds, :to_string, :evaluate, :get_time, :stop_timer, :start_timer
    mtds.each do |mtd|
      assert_respond_to @client, mtd, "Doesn't repond to #{mtd}" 
    end
  end

  def test_get_time
    input = 1, 60, 18290, 86400, 86402
    result = "1 second", "1 minute", "5 hours, 4 minutes, 50 seconds", "1 day", "1 day, 2 seconds"

    input.each_with_index do |arg, i|
      assert_equal result[i], @client.get_time(arg)
    end
  end

  def test_get_seconds
    @client.stub(:stop, 100) do 
      @client.stub(:start, 14) do 
        assert_equal 86, @client.get_seconds
      end
    end
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
    expect = ['1 hour', '5 minutes', nil, '1 second', '6 hours']

    input.each_index do |i|
      time = input[i][0]
      unit = input[i][1]
      assert_equal(expect[i], @client.to_string(time, unit))
    end
  end

  def test_to_string_nil
    assert_nil @client.to_string(0, '')
  end
end
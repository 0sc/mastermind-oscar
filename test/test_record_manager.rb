require 'minitest/autorun'
require 'minitest/reporters'
require "mastermind/oscar/record_manager"
require "stringio"

class RecordManagerTest < Minitest::Test
  def setup
    difficulty = :intermediate
    @client = Mastermind::Oscar::RecordManager.new(:intermediate, StringIO.new("Adebayo\n"))
  end

  def test_initialize
    assert_equal(@client.user, "Adebayo")
  end

  def test_set_user
  	@client.set_read_stream(StringIO.new("Oscar\n"))
  	@client.set_user
  	assert_equal("Oscar", @client.user)
  end
end
require 'minitest/autorun'
require 'minitest/reporters'
require "mastermind/oscar/record_manager"
require "stringio"

class RecordManagerTest < Minitest::Test
  def setup
    @client = Mastermind::Oscar::RecordManager.new
  end

  def test_set_user
  	@client.set_read_stream(StringIO.new("Oscar\n"))
  	@client.set_user
  	assert_equal("Oscar", @client.user)
  end
end
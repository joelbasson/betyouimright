require 'test_helper'

class BetTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert Bet.new.valid?
  end
end

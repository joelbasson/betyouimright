require 'test_helper'

class BonusTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert Bonus.new.valid?
  end
end

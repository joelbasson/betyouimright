require 'test_helper'

class CashoutTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert Cashout.new.valid?
  end
end

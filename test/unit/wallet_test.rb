require 'test_helper'

class WalletTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert Wallet.new.valid?
  end
end

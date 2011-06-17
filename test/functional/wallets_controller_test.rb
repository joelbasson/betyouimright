require 'test_helper'

class WalletsControllerTest < ActionController::TestCase
  def test_show
    get :show, :id => Wallet.first
    assert_template 'show'
  end
end

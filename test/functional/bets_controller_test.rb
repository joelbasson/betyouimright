require 'test_helper'

class BetsControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end

  def test_show
    get :show, :id => Bet.first
    assert_template 'show'
  end

  def test_new
    get :new
    assert_template 'new'
  end

  def test_create_invalid
    Bet.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end

  def test_create_valid
    Bet.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to bet_url(assigns(:bet))
  end

  def test_edit
    get :edit, :id => Bet.first
    assert_template 'edit'
  end

  def test_update_invalid
    Bet.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Bet.first
    assert_template 'edit'
  end

  def test_update_valid
    Bet.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Bet.first
    assert_redirected_to bet_url(assigns(:bet))
  end

  def test_destroy
    bet = Bet.first
    delete :destroy, :id => bet
    assert_redirected_to bets_url
    assert !Bet.exists?(bet.id)
  end
end

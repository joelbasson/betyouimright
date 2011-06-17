require 'test_helper'

class BonusesControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end

  def test_show
    get :show, :id => Bonus.first
    assert_template 'show'
  end

  def test_new
    get :new
    assert_template 'new'
  end

  def test_create_invalid
    Bonus.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end

  def test_create_valid
    Bonus.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to bonus_url(assigns(:bonus))
  end

  def test_edit
    get :edit, :id => Bonus.first
    assert_template 'edit'
  end

  def test_update_invalid
    Bonus.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Bonus.first
    assert_template 'edit'
  end

  def test_update_valid
    Bonus.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Bonus.first
    assert_redirected_to bonus_url(assigns(:bonus))
  end

  def test_destroy
    bonus = Bonus.first
    delete :destroy, :id => bonus
    assert_redirected_to bonuses_url
    assert !Bonus.exists?(bonus.id)
  end
end

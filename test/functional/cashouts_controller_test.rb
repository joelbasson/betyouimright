require 'test_helper'

class CashoutsControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end

  def test_show
    get :show, :id => Cashout.first
    assert_template 'show'
  end

  def test_new
    get :new
    assert_template 'new'
  end

  def test_create_invalid
    Cashout.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end

  def test_create_valid
    Cashout.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to cashout_url(assigns(:cashout))
  end

  def test_edit
    get :edit, :id => Cashout.first
    assert_template 'edit'
  end

  def test_update_invalid
    Cashout.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Cashout.first
    assert_template 'edit'
  end

  def test_update_valid
    Cashout.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Cashout.first
    assert_redirected_to cashout_url(assigns(:cashout))
  end

  def test_destroy
    cashout = Cashout.first
    delete :destroy, :id => cashout
    assert_redirected_to cashouts_url
    assert !Cashout.exists?(cashout.id)
  end
end

require 'test_helper'

class PurchasesControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end

  def test_show
    get :show, :id => Purchases.first
    assert_template 'show'
  end

  def test_new
    get :new
    assert_template 'new'
  end

  def test_create_invalid
    Purchases.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end

  def test_create_valid
    Purchases.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to purchases_url(assigns(:purchases))
  end

  def test_edit
    get :edit, :id => Purchases.first
    assert_template 'edit'
  end

  def test_update_invalid
    Purchases.any_instance.stubs(:valid?).returns(false)
    put :update, :id => Purchases.first
    assert_template 'edit'
  end

  def test_update_valid
    Purchases.any_instance.stubs(:valid?).returns(true)
    put :update, :id => Purchases.first
    assert_redirected_to purchases_url(assigns(:purchases))
  end

  def test_destroy
    purchases = Purchases.first
    delete :destroy, :id => purchases
    assert_redirected_to purchases_url
    assert !Purchases.exists?(purchases.id)
  end
end

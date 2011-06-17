require 'test_helper'

class BetCategoriesControllerTest < ActionController::TestCase
  def test_index
    get :index
    assert_template 'index'
  end

  def test_show
    get :show, :id => BetCategory.first
    assert_template 'show'
  end

  def test_new
    get :new
    assert_template 'new'
  end

  def test_create_invalid
    BetCategory.any_instance.stubs(:valid?).returns(false)
    post :create
    assert_template 'new'
  end

  def test_create_valid
    BetCategory.any_instance.stubs(:valid?).returns(true)
    post :create
    assert_redirected_to bet_category_url(assigns(:bet_category))
  end

  def test_edit
    get :edit, :id => BetCategory.first
    assert_template 'edit'
  end

  def test_update_invalid
    BetCategory.any_instance.stubs(:valid?).returns(false)
    put :update, :id => BetCategory.first
    assert_template 'edit'
  end

  def test_update_valid
    BetCategory.any_instance.stubs(:valid?).returns(true)
    put :update, :id => BetCategory.first
    assert_redirected_to bet_category_url(assigns(:bet_category))
  end

  def test_destroy
    bet_category = BetCategory.first
    delete :destroy, :id => bet_category
    assert_redirected_to bet_categories_url
    assert !BetCategory.exists?(bet_category.id)
  end
end

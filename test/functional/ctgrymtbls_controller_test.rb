require 'test_helper'

class CtgrymtblsControllerTest < ActionController::TestCase
  setup do
    @ctgrymtbl = ctgrymtbls(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:ctgrymtbls)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create ctgrymtbl" do
    assert_difference('Ctgrymtbl.count') do
      post :create, :ctgrymtbl => @ctgrymtbl.attributes
    end

    assert_redirected_to ctgrymtbl_path(assigns(:ctgrymtbl))
  end

  test "should show ctgrymtbl" do
    get :show, :id => @ctgrymtbl.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @ctgrymtbl.to_param
    assert_response :success
  end

  test "should update ctgrymtbl" do
    put :update, :id => @ctgrymtbl.to_param, :ctgrymtbl => @ctgrymtbl.attributes
    assert_redirected_to ctgrymtbl_path(assigns(:ctgrymtbl))
  end

  test "should destroy ctgrymtbl" do
    assert_difference('Ctgrymtbl.count', -1) do
      delete :destroy, :id => @ctgrymtbl.to_param
    end

    assert_redirected_to ctgrymtbls_path
  end
end

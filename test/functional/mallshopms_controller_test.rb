require 'test_helper'

class MallshopmsControllerTest < ActionController::TestCase
  setup do
    @mallshopm = mallshopms(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:mallshopms)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create mallshopm" do
    assert_difference('Mallshopm.count') do
      post :create, :mallshopm => @mallshopm.attributes
    end

    assert_redirected_to mallshopm_path(assigns(:mallshopm))
  end

  test "should show mallshopm" do
    get :show, :id => @mallshopm.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @mallshopm.to_param
    assert_response :success
  end

  test "should update mallshopm" do
    put :update, :id => @mallshopm.to_param, :mallshopm => @mallshopm.attributes
    assert_redirected_to mallshopm_path(assigns(:mallshopm))
  end

  test "should destroy mallshopm" do
    assert_difference('Mallshopm.count', -1) do
      delete :destroy, :id => @mallshopm.to_param
    end

    assert_redirected_to mallshopms_path
  end
end

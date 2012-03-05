require 'test_helper'

class CustsControllerTest < ActionController::TestCase
  setup do
    @cust = custs(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:custs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create cust" do
    assert_difference('Cust.count') do
      post :create, :cust => @cust.attributes
    end

    assert_redirected_to cust_path(assigns(:cust))
  end

  test "should show cust" do
    get :show, :id => @cust.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @cust.to_param
    assert_response :success
  end

  test "should update cust" do
    put :update, :id => @cust.to_param, :cust => @cust.attributes
    assert_redirected_to cust_path(assigns(:cust))
  end

  test "should destroy cust" do
    assert_difference('Cust.count', -1) do
      delete :destroy, :id => @cust.to_param
    end

    assert_redirected_to custs_path
  end
end

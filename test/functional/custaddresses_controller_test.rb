require 'test_helper'

class CustaddressesControllerTest < ActionController::TestCase
  setup do
    @custaddress = custaddresses(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:custaddresses)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create custaddress" do
    assert_difference('Custaddress.count') do
      post :create, :custaddress => @custaddress.attributes
    end

    assert_redirected_to custaddress_path(assigns(:custaddress))
  end

  test "should show custaddress" do
    get :show, :id => @custaddress.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @custaddress.to_param
    assert_response :success
  end

  test "should update custaddress" do
    put :update, :id => @custaddress.to_param, :custaddress => @custaddress.attributes
    assert_redirected_to custaddress_path(assigns(:custaddress))
  end

  test "should destroy custaddress" do
    assert_difference('Custaddress.count', -1) do
      delete :destroy, :id => @custaddress.to_param
    end

    assert_redirected_to custaddresses_path
  end
end

require 'test_helper'

class ComdtiesControllerTest < ActionController::TestCase
  setup do
    @comdty = comdties(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:comdties)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create comdty" do
    assert_difference('Comdty.count') do
      post :create, :comdty => @comdty.attributes
    end

    assert_redirected_to comdty_path(assigns(:comdty))
  end

  test "should show comdty" do
    get :show, :id => @comdty.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @comdty.to_param
    assert_response :success
  end

  test "should update comdty" do
    put :update, :id => @comdty.to_param, :comdty => @comdty.attributes
    assert_redirected_to comdty_path(assigns(:comdty))
  end

  test "should destroy comdty" do
    assert_difference('Comdty.count', -1) do
      delete :destroy, :id => @comdty.to_param
    end

    assert_redirected_to comdties_path
  end
end

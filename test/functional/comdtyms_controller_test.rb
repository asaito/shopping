require 'test_helper'

class ComdtymsControllerTest < ActionController::TestCase
  setup do
    @comdtym = comdtyms(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:comdtyms)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create comdtym" do
    assert_difference('Comdtym.count') do
      post :create, :comdtym => @comdtym.attributes
    end

    assert_redirected_to comdtym_path(assigns(:comdtym))
  end

  test "should show comdtym" do
    get :show, :id => @comdtym.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @comdtym.to_param
    assert_response :success
  end

  test "should update comdtym" do
    put :update, :id => @comdtym.to_param, :comdtym => @comdtym.attributes
    assert_redirected_to comdtym_path(assigns(:comdtym))
  end

  test "should destroy comdtym" do
    assert_difference('Comdtym.count', -1) do
      delete :destroy, :id => @comdtym.to_param
    end

    assert_redirected_to comdtyms_path
  end
end

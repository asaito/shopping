require 'test_helper'

class CmdtystndrdmsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

end

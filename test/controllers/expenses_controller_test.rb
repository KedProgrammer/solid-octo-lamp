require 'test_helper'

class ExpensesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get expenses_path
    assert_response :success
  end

end

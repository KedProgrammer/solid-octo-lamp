require 'test_helper'

class Api::V1::ExpensesControllerTest < ActionDispatch::IntegrationTest
  test "get index response should be success" do
    get api_v1_expenses_path, xhr: true
    assert_response :success
  end

  test "get index should return list of expenses" do
    get api_v1_expenses_path, xhr: true

    body = JSON.parse(response.body)
    assert_not_nil body
    assert_equal 2, body.length
  end

  test "post create response should be success" do
    post api_v1_expenses_path, params: { expense: { type: :purchase, date: Date.current, concept: "Hello World", category_id: categories(:car).id, amount: 20 } }, xhr: true
    assert_response :success
  end

  test "should create expense" do
    assert_difference "Expense.count" do
      post api_v1_expenses_path, params: { expense: { type: :purchase, date: Date.current, concept: "Hello World", category_id: categories(:car).id, amount: 20 } }, xhr: true
    end
  end

  test "should not create an expense without concept" do
    assert_no_difference "Expense.count" do
      post api_v1_expenses_path, params: { expense: { type: :purchase, date: Date.current, category_id: categories(:car).id, amount: 20 } }, xhr: true
    end
  end

  test "patch update response should be success" do
    patch api_v1_expense_path(expenses(:hamburger)), params: { expense: { type: :purchase, date: Date.current, concept: "Hello World", category_id: categories(:car).id, amount: 20 } }, xhr: true
    assert_response :success
  end

  test "patch update should update the expense" do
    expense = expenses(:hamburger)
    patch api_v1_expense_path(expense), params: { expense: { type: :withdrawal, date: 1.month.ago.to_date, concept: "Hello World", category_id: categories(:car).id, amount: 20 } }, xhr: true

    expense.reload
    assert_equal "withdrawal", expense.type
    assert_equal 1.month.ago.to_date, expense.date
    assert_equal "Hello World", expense.concept
    assert_equal categories(:car), expense.category
    assert_equal 20, expense.amount
  end

  test "delete destroy response should be success" do
    delete api_v1_expense_path(expenses(:hamburger))
    assert_response :success
  end

  test "delete destroy should delete the expense" do
    assert_difference "Expense.count", -1 do
      delete api_v1_expense_path(expenses(:hamburger))
    end
  end

end

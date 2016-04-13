require 'test_helper'

class ExpensesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get expenses_path
    assert_response :success
  end

  test "should render index template" do
    get expenses_path
    assert_template :index
  end

  test "get index should assign the current month" do
    get expenses_path
    assert_equal Date.current.beginning_of_month, assigns(:month)
  end

  test "get index should assign the correct expenses" do
    get expenses_path
    assert_equal Expense.all.to_a, assigns(:expenses).to_a
  end

  test "get index should assign the correct total" do
    get expenses_path
    assert_equal Expense.all.map(&:amount).reduce(&:+), assigns(:total)
  end

  test "get index should list the correct expenses with type filter" do
    expense = Expense.create!(type: :withdrawal, date: Date.current, concept: "Hello", amount: 10, category_id: categories(:restaurants).id)

    get expenses_path, params: { type: :withdrawal }
    assert_equal [expense], assigns(:expenses).to_a
  end

  test "get index should list the correct expenses with category filter" do
    get expenses_path, params: { category_id: categories(:car).id }
    assert_equal [expenses(:gasoline)], assigns(:expenses).to_a
  end

  test "get index should list the correct expenses with date filter" do
    a_month_ago = 1.month.ago
    expense = Expense.create!(type: :purchase, date: 1.month.ago.to_date, concept: "Hello", amount: 10, category_id: categories(:restaurants).id)

    get expenses_path, params: { year: a_month_ago.year, month: a_month_ago.month }
    assert_equal [expense], assigns(:expenses).to_a
  end

  test "get index should list the correct expenses with all filters" do
    a_month_ago = 1.month.ago
    expense = Expense.create!(type: :purchase, date: 1.month.ago.to_date, concept: "Hello", amount: 10, category_id: categories(:restaurants).id)

    get expenses_path, params: { type: :purchase, category_id: categories(:restaurants).id, year: a_month_ago.year, month: a_month_ago.month }
    assert_equal [expense], assigns(:expenses).to_a
  end

  test "should get new" do
    get new_expense_path, xhr: true
    assert_response :success
  end

  test "should render new template" do
    get new_expense_path, xhr: true
    assert_template :new
  end

  test "get new should assign expense" do
    get new_expense_path, xhr: true
    assert_not_nil assigns(:expense)
  end

  test "should create a new expense" do
    assert_difference "Expense.count" do
      post expenses_path(expense: { type: "purchase", date: Date.current, concept: "Hello", amount: 12000, category_id: categories(:restaurants).id }), xhr: true
    end

    expense = Expense.last
    assert_equal "purchase", expense.type
    assert_equal Date.current, expense.date
    assert_equal "Hello", expense.concept
    assert_equal 12000, expense.amount
    assert_equal categories(:restaurants).id, expense.category_id
  end

  test "should not create an expense with empty concept" do
    assert_no_difference "Expense.count" do
      post expenses_path(expense: { type: "purchase", date: Date.current, concept: "", amount: 12000, category_id: categories(:restaurants).id }), xhr: true
    end
  end

  test "should get edit" do
    get edit_expense_path(expenses(:hamburger)), xhr: true
    assert_response :success
  end

  test "should render edit template" do
    get edit_expense_path(expenses(:hamburger)), xhr: true
    assert_template :edit
  end

  test "get edit should assign expense" do
    get edit_expense_path(expenses(:hamburger)), xhr: true
    assert_not_nil assigns(:expense)
  end

  test "should patch update" do
    patch expense_path(id: expenses(:hamburger)), params: { expense: { type: "withdrawal", concept: "Hello", amount: 10, category_id: categories(:car).id } }, xhr: true
    assert_response :success
  end

  test "should update expense" do
    id = expenses(:hamburger).id
    assert_no_difference "Expense.count" do
      patch expense_path(id: id), params: { expense: { type: "withdrawal", date: 1.month.ago.to_date, concept: "Hello", amount: 100, category_id: categories(:car).id } }, xhr: true
    end

    expense = Expense.find(id)
    assert_equal "withdrawal", expense.type
    assert_equal 1.month.ago.to_date, expense.date
    assert_equal "Hello", expense.concept
    assert_equal 100, expense.amount
    assert_equal categories(:car).id, expense.category_id
  end

  test "should delete destroy" do
    delete expense_path(expenses(:gasoline)), xhr: true
    assert_response :success
  end

  test "delete destroy should render template" do
    delete expense_path(expenses(:gasoline)), xhr: true
    assert_template :destroy
  end

  test "should destroy a expense" do
    assert_difference "Expense.count", -1 do
      delete expense_path(expenses(:gasoline)), xhr: true
    end
  end
end

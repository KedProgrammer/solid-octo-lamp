require 'test_helper'

class ExpenseTest < ActiveSupport::TestCase
  test "should assign default values" do
    expense = Expense.new
    assert_equal Date.current, expense.date
    assert_equal 0, expense.amount
  end

  test "should save a new expense" do
    expense = Expense.new(type: :purchase, concept: "A concept", date: 1.day.ago, amount: 10, category: categories(:car))
    assert expense.save
  end

  test "should not save a expense without a type" do
    expense = Expense.new(concept: "A concept", date: 1.day.ago, amount: 10, category: categories(:car))
    assert_not expense.save
  end

  test "should not initialize a expense with an invalid type" do
    assert_raises ArgumentError do
      expense = Expense.new(type: :invalid, concept: "A concept", date: 1.day.ago, amount: 10, category: categories(:car))
    end
  end

  test "should not save a expense without a concept" do
    expense = expenses(:hamburger)
    expense.concept = nil

    assert_not expense.save
  end

  test "should not save a expense without an amount" do
    expense = expenses(:hamburger)
    expense.amount = nil

    assert_not expense.save
  end

  test "should not save a expense with a negative amount" do
    expense = expenses(:hamburger)
    expense.amount = -10

    assert_not expense.save
  end

  test "should not save a expense without a category" do
    expense = expenses(:hamburger)
    expense.category = nil

    assert_not expense.save
  end

  test "spent_by_month_and_type should return the correct values" do
    expected = [{
      date: 1.month.ago.beginning_of_month.to_date,
      "purchase" => 0,
      "withdrawal" => 0,
      "transfer" => 0,
      "payment" => 0
    }, {
      date: Date.current.beginning_of_month,
      "purchase" => 20,
      "withdrawal" => 0,
      "transfer" => 0,
      "payment" => 0
    }]

    range = 1.month.ago.beginning_of_month.to_date..Date.current
    assert_equal expected, Expense.spent_by_month_and_type(range)
  end

  test "spent_by_day_and_type should return the correct values" do
    expected = [{
      date: 1.day.ago.to_date,
      "purchase" => 0,
      "withdrawal" => 0,
      "transfer" => 0,
      "payment" => 0
    }, {
      date: Date.current,
      "purchase" => Expense.all.map(&:amount).reduce(&:+),
      "withdrawal" => 0,
      "transfer" => 0,
      "payment" => 0
    }]

    range = 1.day.ago.to_date..Date.current
    assert_equal expected, Expense.spent_by_day_and_type(range)
  end

  test "spent_by_category should return the correct values" do
    expected = {}
    expected[categories(:restaurants).id] = 10
    expected[categories(:car).id] = 10

    range = Date.current.beginning_of_month..Date.current
    assert_equal expected, Expense.spent_by_category(range)
  end

  test "accumulated_by_day should return the the correct values" do
    range = Date.current.beginning_of_month..Date.current
    expected = range.map { |date| { date: date, amount: 0 } }
    expected[-1] = { date: Date.current, amount: 20 }

    assert_equal expected, Expense.accumulated_by_day(range)
  end
end

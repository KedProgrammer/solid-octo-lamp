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
end

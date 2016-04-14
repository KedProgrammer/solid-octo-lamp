require 'test_helper'

class DashboardHelperTest < ActiveSupport::TestCase
  include DashboardHelper

  test "spent_between should return the amount spent this month" do
    expected = Expense.all.map(&:amount).reduce(&:+)
    Expense.create!(type: :purchase, date: 1.month.ago, concept: "Hello", amount: 30, category: categories(:car))

    assert_equal expected, spent_between(current_month_range)
  end
end

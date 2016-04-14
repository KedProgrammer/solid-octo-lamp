require 'test_helper'

class CreateExpenseTest < ActionDispatch::IntegrationTest
  test "creates an expense" do
    Capybara.current_driver = Capybara.javascript_driver
    visit "/expenses"

    click_link "New Expense"
    page.must_have_css(".expense-modal")

    fill_in "Concept", with: "Hola"
    fill_in "Amount", with: 20
    click_button "Create expense"

    page.must_have_content "was created successfully!"
    page.must_have_content "Hola"

    Capybara.use_default_driver
  end
end

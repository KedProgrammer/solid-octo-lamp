require 'test_helper'

class CategoryTest < ActiveSupport::TestCase
  test "saves a new category" do
    category = Category.new(name: "Restaurants")
    assert category.save
  end

  test "should not save a category without name" do
    category = Category.new
    assert_not category.save
  end
end

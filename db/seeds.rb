Category.create(name: "Restaurants")
Category.create(name: "Grocery")
Category.create(name: "Car")
Category.create(name: "Services")
Category.create(name: "Home")
Category.create(name: "Education")
Category.create(name: "Fun")
Category.create(name: "Travel")

5.downto(0).each do |i|
  first_day = i.months.ago.beginning_of_month.to_date
  last_day = first_day.end_of_month.to_date

  first_day.upto(last_day) do |date|
    Expense.create(type: Expense.types.keys.sample, concept: Faker::Commerce.product_name,
      date: date, amount: Faker::Number.between(30_000, 1_500_000), category: Category.all.sample)
  end
end

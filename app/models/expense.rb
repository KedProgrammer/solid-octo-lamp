class Expense < ApplicationRecord
  self.inheritance_column = nil

  belongs_to :category

  enum type: [:purchase, :withdrawal, :transfer, :payment]

  scope :between, lambda { |range| where(date: range) }

  validates :type, presence: true
  validates :concept, presence: true
  validates :amount, presence: true, numericality: { greater_than_or_equal_to: 0 }

  after_initialize :default_values

  # Returns an array of hashes grouped by month with the following format:
  # [{
  #   date: <a date representing a month>,
  #   purchase: 100,
  #   withdrawal: 200,
  #   ... other types of expenses
  # }]
  def self.spent_by_month_and_type(range)
    bmt = by_date_and_type('month', range)

    # create the hashes, one per month
    per_month(range).map { |date| hash_for_date(bmt, date) }
  end

  def self.spent_by_day_and_type(range)
    bdt = by_date_and_type('day', range)

    (range.min.to_date..range.max.to_date).map { |date| hash_for_date(bdt, date) }
  end

  def self.spent_by_category(range)
    between(range).group(:category_id).sum(:amount)
  end

  def self.accumulated_by_day(range)
    by_day = between(range).group("date_trunc('day', date)").sum(:amount)
    by_day = Hash[by_day.map { |key, value| [key.to_date, value] }] # convert Time to Date

    amount = 0
    (range.min.to_date..range.max.to_date).map do |date|
      amount += by_day.fetch(date, BigDecimal.new('0'))
      { date: date, amount: amount }
    end
  end

  private
    def default_values
      self.date ||= Date.current
      self.amount ||= 0
    end

    def self.per_month(range)
      (range.min.to_date..range.max.to_date).select { |d| d.day == 1 }
    end

    # groups by date and type, e.g:
    # { [<date>, 'purchase'] => 12000,
    #   [<date>, 'withdrawal'] => 13000,
    #   ... }
    def self.by_date_and_type(truncate_by, range)
      bdt = between(range).group(["date_trunc('#{truncate_by}', date)", "type"]).sum(:amount)
      Hash[bdt.map { |key, value| [[key[0].to_date, types.key(key[1])], value] }] # convert Time to Date
    end

    def self.hash_for_date(grouped_expenses, date)
      types.keys.each_with_object({ date: date }) do |type, hash|
        hash[type] = grouped_expenses.fetch([date, type.to_s], BigDecimal.new('0'))
      end
    end
end

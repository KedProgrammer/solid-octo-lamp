class Expense < ApplicationRecord
  self.inheritance_column = nil

  belongs_to :category

  enum type: [:purchase, :withdrawal, :transfer, :payment]

  scope :between, lambda { |range| where(date: range) }

  after_initialize :default_values

  private
    def default_values
      self.date ||= Date.current
      self.amount ||= 0
    end
end

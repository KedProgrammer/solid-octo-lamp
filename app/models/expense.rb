class Expense < ApplicationRecord
  self.inheritance_column = nil

  belongs_to :category

  enum type: [:purchase, :withdrawal, :transfer, :payment]

  scope :between, lambda { |range| where(date: range) }

  validates :type, presence: true
  validates :concept, presence: true
  validates :amount, presence: true, numericality: { greater_than_or_equal_to: 0 }

  after_initialize :default_values

  private
    def default_values
      self.date ||= Date.current
      self.amount ||= 0
    end
end

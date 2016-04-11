class ExpensesController < ApplicationController
  def index
    @month = Date.new(year, month, 1)
    @expenses = Expense.between(@month..@month.end_of_month).order("date DESC")
    @expenses = @expenses.where(type: params[:type]) if params[:type]
    @expenses = @expenses.where(category_id: params[:category]) if params[:category]

    @total = @expenses.map(&:amount).reduce(&:+)

    @tab = :expenses
  end

  def new
    @expense = Expense.new
  end

  private
    def year
      params[:year] ? params[:year].to_i : Date.current.year
    end

    def month
      params[:month] ? params[:month].to_i : Date.current.month
    end
end

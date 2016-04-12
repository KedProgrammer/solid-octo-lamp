class ExpensesController < ApplicationController
  def index
    populate_index_data
    @tab = :expenses
  end

  def new
    @expense = Expense.new
  end

  def create
    @expense = Expense.create(expenses_params)
    populate_index_data if @expense.valid?
  end

  private
    def populate_index_data
      @month = Date.new(year, month, 1)
      @expenses = Expense.between(@month..@month.end_of_month).order("date DESC")
      @expenses = @expenses.where(type: params[:type]) if params[:type]
      @expenses = @expenses.where(category_id: params[:category]) if params[:category]

      @total = @expenses.map(&:amount).reduce(&:+)
    end

    def year
      params[:year] ? params[:year].to_i : Date.current.year
    end

    def month
      params[:month] ? params[:month].to_i : Date.current.month
    end

    def expenses_params
      params.require(:expense).permit(:type, :date, :concept, :category_id, :amount)
    end
end

class ExpensesController < ApplicationController
  def index
    populate_index_data(params.to_unsafe_h)
    cookies[:expenses_filter] = request.query_parameters.to_json
    @tab = :expenses
  end

  def new
    @expense = Expense.new
  end

  def create
    @expense = Expense.create(expenses_params)
    populate_index_data(JSON.parse(cookies[:expenses_filter], symbolize_names: true)) if @expense.valid?
  end

  def destroy
    @expense = Expense.destroy(params[:id])
    populate_index_data(JSON.parse(cookies[:expenses_filter], symbolize_names: true))
  end

  private
    def populate_index_data(params)
      puts "Populate index data: #{params}"
      @month = Date.new(year(params), month(params), 1)
      @expenses = Expense.between(@month..@month.end_of_month).order("date DESC")
      @expenses = @expenses.where(type: params[:type]) if params[:type]
      @expenses = @expenses.where(category_id: params[:category]) if params[:category]

      @total = @expenses.map(&:amount).reduce(&:+)
    end

    def year(params)
      params[:year] ? params[:year].to_i : Date.current.year
    end

    def month(params)
      params[:month] ? params[:month].to_i : Date.current.month
    end

    def expenses_params
      params.require(:expense).permit(:type, :date, :concept, :category_id, :amount)
    end
end

class Api::V1::ExpensesController < ApplicationController
  protect_from_forgery with: :null_session

  def index
    render json: Expense.all
  end

  def create
    expense = Expense.new(expense_params)
    if expense.save
      render json: expense, status: 201
    else
      render json: { errors: expense.errors }, status: 422
    end
  end

  def update
    expense = Expense.find(params[:id])
    if expense.update(expense_params)
      render json: expense, status: 200
    else
      render json: { errors: expense.errors }, status: 422
    end
  end

  def destroy
    expense = Expense.find(params[:id])
    expense.destroy
    head 204
  end

  private
    def expense_params
      params.require(:expense).permit(:type, :date, :concept, :category_id, :amount)
    end
end

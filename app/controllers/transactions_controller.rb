class TransactionsController < ApplicationController
  def index
    scope = Transaction.all
    scope = scope.where(kind: filter_params[:kind]) if filter_params[:kind]
    scope = scope.where(blockchain: filter_params[:blockchain]) if filter_params[:blockchain]
    @transactions = scope.order(time: :desc).page(params[:page])

  end

  def filter_params
    params.permit(:kind, :blockchain)
  end
end

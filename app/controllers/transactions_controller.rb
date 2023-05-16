class TransactionsController < ApplicationController
  def index
    @transactions = Transaction.order(time: :desc).page(params[:page])
  end
end

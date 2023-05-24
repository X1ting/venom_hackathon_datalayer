class AccountsController < ApplicationController
  def index
    scope = Account.all
    scope = scope.where(blockchain: filter_params[:blockchain]) if filter_params[:blockchain]

    @accounts = scope.order(created_at: :desc).page(params[:page])
  end

  def show
    @account = Account.find(params[:id])
    # @ch_balances = @account.ch_accounts.select(:created_at_local, :balance_dec).order(created_at_local: :desc).last(100)
    @balance = @account.ch_accounts
      .select(:created_at_local, :balance_dec)
      .order(created_at_local: :desc)
      .last(100)
      .reduce({}) {|acc, i|  acc[i.created_at_local] = format_amount(i.balance_dec); acc }
  end

  def filter_params
    params.permit(:blockchain)
  end

  def format_amount(amount)
    amount.to_f / 1000000000
  end
end

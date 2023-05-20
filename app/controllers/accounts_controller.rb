class AccountsController < ApplicationController
  def index
    @accounts = Account.order(created_at: :desc).page(params[:page])
  end

  def show
    @account = Account.find(params[:id])
    @ch_balances = @account.ch_accounts.select(:created_at_local, :balance_dec).order(created_at_local: :desc).last(100)
  end
end

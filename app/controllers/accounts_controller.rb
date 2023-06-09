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
    # @balance = @account.ch_accounts
    #   .select('toStartOfFifteenMinutes(created_at_local) as created_at, avg(balance_dec::int) as avg_balance')
    #   .group('toStartOfFifteenMinutes(created_at_local) as created_at')
    #   .order(created_at: :desc)
    #   .limit(1000).to_a
    #   .reduce({}) {|acc, i|  acc[i.created_at] = format_amount(i.avg_balance); acc }
    @decoded_messages = @account.decoded_messages.order(ext_created_at: :desc).page(params[:page])
  end

  def filter_params
    params.permit(:blockchain)
  end

  def format_amount(amount)
    amount.to_f / 1000000000
  end
end

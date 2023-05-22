class SearchController < ApplicationController
  def search
    account = Account.find_by(id: params[:q])
    account ||= Account.find_by(address: params[:q])
    redirect_to account_path(account) and return if account.present?

    transaction = Transaction.find_by(id: params[:q])
    transaction ||= Transaction.find_by(tx_id: params[:q])
    redirect_to transaction_path(transaction) and return if transaction.present?

    redirect_to root_path, alert: "Nothing found by: #{params[:q]}"
  end
end

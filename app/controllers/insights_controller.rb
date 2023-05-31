class InsightsController < ApplicationController
  def index
    redirect_to insights_path, notice: "Date is invalid" and return if params[:since].present? && !valid_date?(params[:since])
    if params[:since].present?
      since = Date.parse(params[:since])
      @transactions = Transaction.where(time: since..)
    else
      @transactions = Transaction.where(time: 1.day.ago..)
    end

    @transactions_insights = [
      {
        name: 'Venom',
        data: @transactions.venom.devnet.group_by_minute(:time, n: 5).count
      },
      {
        name: 'Everscale',
        data: @transactions.everscale.mainnet.group_by_minute(:time, n: 5).count
      },
      {
        name: 'Devnet Drop',
        data: @transactions.devnet_drop.group_by_minute(:time, n: 5).count
      },
      {
        name: 'Funds Transfer',
        data: @transactions.funds_transfer.group_by_minute(:time, n: 5).count
      }
    ]

    if params[:since].present?
      since = Date.parse(params[:since])
      @accounts = Account.where(created_at: since..)
    else
      @accounts = Account.where(created_at: 1.day.ago..)
    end

    @accounts_insights = [
      {
        name: 'Venom',
        data: @accounts.venom.devnet.group_by_minute(:created_at, n: 5).count
      },
      {
        name: 'Everscale',
        data: @accounts.everscale.mainnet.group_by_minute(:created_at, n: 5).count
      },
      {
        name: 'NFT',
        data: @accounts.nft.group_by_minute(:created_at, n: 5).count
      },
      {
        name: 'Wallets',
        data: @accounts.wallet.group_by_minute(:created_at, n: 5).count
      }
    ]

    if params[:since].present?
      since = Date.parse(params[:since])
      @events = DecodedMessage.where(ext_created_at: since..)
    else
      @events = DecodedMessage.where(ext_created_at: 1.day.ago..)
    end

    @events_insights = @events.pluck(:name).uniq.map do |method_name|
      {
        name: method_name,
        data: @events.where(name: method_name).group_by_minute(:ext_created_at, n: 15).count
      }
    end
  end


  def valid_date?(date)
    Date.parse(date)
  rescue Date::Error
    false
  end
end

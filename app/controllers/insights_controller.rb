class InsightsController < ApplicationController
  def index
    redirect_to insights_path, notice: "Since date is invalid" and return unless valid_date?(params[:since])
    redirect_to insights_path, notice: "Until date is invalid" and return unless valid_date?(params[:until])

    if params[:since].present?
      @transactions = Transaction.where(time: Date.parse(params[:since])..)
      @accounts = Account.where(created_at: Date.parse(params[:since])..)
      @events = DecodedMessage.where(ext_created_at: Date.parse(params[:since])..)
    else
      @transactions = Transaction.where(time: 1.day.ago..)
      @accounts = Account.where(created_at: 1.day.ago..)
      @events = DecodedMessage.where(ext_created_at: 1.day.ago..)
    end

    if params[:until].present?
      @transactions = Transaction.where(time: ..Date.parse(params[:until]))
      @accounts = Account.where(created_at: ..Date.parse(params[:until]))
      @events = DecodedMessage.where(ext_created_at: ..Date.parse(params[:until]))
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

    @events_insights = @events.pluck(:name).uniq.map do |method_name|
      {
        name: method_name,
        data: @events.where(name: method_name).group_by_minute(:ext_created_at, n: 15).count
      }
    end
  end
end

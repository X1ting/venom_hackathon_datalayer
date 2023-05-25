class InsightsController < ApplicationController
  def index
    @transactions = Transaction.where(created_at: 1.day.ago..)
    @transactions_insights = [
      {
        name: 'Venom',
        data: @transactions.venom.devnet.group_by_minute(:created_at, n: 5).count
      },
      {
        name: 'Everscale',
        data: @transactions.everscale.mainnet.group_by_minute(:created_at, n: 5).count
      },
      {
        name: 'Devnet Drop',
        data: @transactions.devnet_drop.group_by_minute(:created_at, n: 5).count
      },
      {
        name: 'Funds Transfer',
        data: @transactions.funds_transfer.group_by_minute(:created_at, n: 5).count
      }
    ]

    @accounts = Account.where(created_at: 1.day.ago..)
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
  end
end

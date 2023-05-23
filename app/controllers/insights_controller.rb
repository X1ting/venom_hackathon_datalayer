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
        name: 'NFT',
        data: @transactions.nft.group_by_minute(:created_at, n: 5).count
      },
      {
        name: 'DEX',
        data: @transactions.dex.group_by_minute(:created_at, n: 5).count
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

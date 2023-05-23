class InsightsController < ApplicationController
  def index
    @transactions = Transaction.where(created_at: 1.day.ago..)
    @transaction_insights = [
      {
        name: 'Venom All',
        data: @transactions.venom.devnet.group_by_minute(:created_at, n: 5).count
      },
      {
        name: 'Everscale All',
        data: @transactions.everscale.mainnet.group_by_minute(:created_at, n: 5).count
      },
      {
        name: 'NFT All',
        data: @transactions.nft.group_by_minute(:created_at, n: 5).count
      },
      {
        name: 'Dex All',
        data: @transactions.nft.group_by_minute(:created_at, n: 5).count
      }
    ]
  end
end

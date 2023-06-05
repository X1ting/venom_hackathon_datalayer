class Account < ApplicationRecord
  include Blockchainable
  paginates_per 20

  enum kind: {
    unknown: 0,
    nft: 1,
    collection: 2,
    wallet: 3
  }

  enum base_currency: {
    venom_coin: 0,
    ever_coin: 1
  }

  def formatted_kind
    kind.to_s.titleize
  end

  def ch_accounts
    ch_account_model.where(id: address)
  end

  def ch_account_model
    clickhouse_module::Account
  end

  def decoded_messages
    DecodedMessage.where(src: self.address).or(DecodedMessage.where(dst: self.address)).left_joins(:contract)
      .joins("LEFT OUTER JOIN accounts as source_accounts ON source_accounts.address = decoded_messages.src")
      .joins("LEFT OUTER JOIN accounts as destination_accounts ON destination_accounts.address = decoded_messages.dst")
      .select('decoded_messages.*, destination_accounts.id as dst_id, source_accounts.id as src_id')
      .order(:ext_created_at)
  end
end

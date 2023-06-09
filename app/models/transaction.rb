class Transaction < PostgresqlRecord
  include Blockchainable

  paginates_per 20

  enum kind: {
    unknown: 0,
    devnet_drop: 1,
    funds_transfer: 2
  }

  scope :nft, -> { where(kind: [kinds[:nft_mint], kinds[:nft_transfer]])}
  scope :dex, -> { where(kind: [kinds[:dex_staking], kinds[:dex_swap]])}

  def formatted_kind
    kind.to_s.titleize
  end
end

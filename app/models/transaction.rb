class Transaction < PostgresqlRecord
  paginates_per 20

  enum kind: {
    unknown: 0,
    nft_mint: 1,
    nft_transfer: 2,
    dex_swap: 3,
    dex_staking: 4,
    devnet_drop: 5
  }

  enum blockchain: {
    venom: 0,
    everscale: 1
  }

  enum network: {
    devnet: 0,
    mainnet: 1
  }

  scope :nft, -> { where(kind: [kinds[:nft_mint], kinds[:nft_transfer]])}
  scope :dex, -> { where(kind: [kinds[:dex_staking], kinds[:dex_swap]])}

  def formatted_kind
    kind.to_s.titleize
  end
end

class Transaction < PostgresqlRecord
  paginates_per 20

  enum kind: {
    unknown: 0,
    nft_mint: 1,
    nft_transfer: 2,
    dex_swap: 3,
    dex_staking: 4
  }

  enum blockchain: {
    venom: 0,
    everscale: 1
  }

  enum network: {
    devnet: 0,
    mainnet: 1
  }

  def formatted_kind
    kind.to_s.titleize
  end

end

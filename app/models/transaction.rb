class Transaction < PostgresqlRecord
  self.primary_key = :tx_id

  enum kind: {
    unknown: 0,
    nft_mint: 1,
    nft_transfer: 2,
    dex_swap: 3,
    dex_staking: 4
  }
  def formatted_kind
    kind.to_s.titleize
  end
end

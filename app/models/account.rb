class Account < ApplicationRecord
  enum kind: {
    unknown: 0,
    nft: 1,
    collection: 2,
    wallet: 3
  }

  enum blockchain: {
    venom: 0,
    everscale: 1
  }

  enum network: {
    devnet: 0,
    mainnet: 1
  }

  enum base_currency: {
    venom_coin: 0,
    ever_coin: 1
  }

  def formatted_kind
    kind.to_s.titleize
  end

end

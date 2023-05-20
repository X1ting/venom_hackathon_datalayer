class Account < ApplicationRecord
  paginates_per 20

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

  def ch_accounts
    ch_account_model.where(id: address)
  end

  def ch_account_model
    if venom? && devnet?
      Clickhouse::Venom::Devnet::Account
    elsif everscale? && mainnet?
      Clickhouse::Everscale::Mainnet::Account
    else
      raise NotImplementedError.new
    end
  end

end

module TransactionHelper
  def truncate_addr(addr)
    addr.truncate(16, omission: "... #{addr.last(4)}")
  end

  def kind_tag_color(kind)
    {
      unknown: "indigo",
      nft_mint: "blue",
      nft_transfer: "pink",
      dex_swap: "emerald",
      dex_staking: "sky"
    }[kind.to_sym]
  end

  def formatted_blockchain(model)
    [model.blockchain, model.network].map(&:titleize).join(" ")
  end

  def blockchain_color(model)
    {
      venom: "emerald",
      everscale: "blue",
    }[model.blockchain.to_sym]
  end

  def format_currency(coin)
    {
      venom_coin: "VENOM",
      ever_coin: "EVER"
    }[coin.to_sym]
  end

  def format_amount(amount)
    amount.to_f / 1000000000
  end

end

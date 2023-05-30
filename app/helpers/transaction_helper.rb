module TransactionHelper
  def truncate_addr(addr)
    addr.truncate(16, omission: "... #{addr.last(4)}")
  end

  def kind_tag_color(kind)
    {
      unknown: "indigo",
      devnet_drop: "emerald",
      funds_transfer: "pink"
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

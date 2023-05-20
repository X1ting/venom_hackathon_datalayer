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

  def blockchain_color(transaction)
    {
      venom: "emerald",
      everscale: "blue",
    }[transaction.blockchain.to_sym]
  end

end

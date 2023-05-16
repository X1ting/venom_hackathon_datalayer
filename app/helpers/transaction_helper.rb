module TransactionHelper
  def truncate_addr(addr)
    addr.truncate(16, omission: "... #{addr.last(4)}")
  end

  def kind_tag_color(kind)
    {
      unknown: "indigo",
      nft_mint: "blue",
      nft_transfer: "pink",
      dex_swap: "green",
      dex_staking: "red"
    }[kind.to_sym]
  end

end

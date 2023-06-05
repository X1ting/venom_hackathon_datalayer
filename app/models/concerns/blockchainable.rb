module Blockchainable
  extend ActiveSupport::Concern
  SUPPORTED_BLOCKCHAINS = {
    venom: ['devnet'],
    everscale: ['mainnet']
  }
  included do
    enum blockchain: {
      venom: 0,
      everscale: 1
    }

    enum network: {
      devnet: 0,
      mainnet: 1
    }
  end

  def blockchain_module
    if venom?
      Venom
    elsif everscale?
      Everscale
    else
      raise NotImplementedError.new
    end
  end

  def network_module
    if devnet?
      Devnet
    elsif mainnet?
      Mainnet
    else
      raise NotImplementedError.new
    end
  end

  def clickhouse_module
    Clickhouse::blockchain_module::network_module
  end
end

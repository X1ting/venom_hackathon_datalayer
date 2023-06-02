module Blockchainable
  extend ActiveSupport::Concern
 
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
end

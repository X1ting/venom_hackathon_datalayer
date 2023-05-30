class DecodedMessage < ApplicationRecord
  paginates_per 20
  enum blockchain: {
    venom: 0,
    everscale: 1
  }

  enum network: {
    devnet: 0,
    mainnet: 1
  }

  belongs_to :source, foreign_key: :src, primary_key: :address, class_name: 'Account', optional: true
  belongs_to :destination, foreign_key: :dst, primary_key: :address, class_name: 'Account', optional: true
  belongs_to :contract, foreign_key: :contract_uuid
end

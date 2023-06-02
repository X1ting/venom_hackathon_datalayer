class DecodedMessage < ApplicationRecord
  include Blockchainable

  paginates_per 20

  belongs_to :source, foreign_key: :src, primary_key: :address, class_name: 'Account', optional: true
  belongs_to :destination, foreign_key: :dst, primary_key: :address, class_name: 'Account', optional: true
  belongs_to :contract, foreign_key: :contract_uuid
end

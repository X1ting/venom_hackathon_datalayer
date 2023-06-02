class Contract < ApplicationRecord
  include Blockchainable
  paginates_per 20
  before_create :validate_abi
  before_save :validate_abi

  has_many :decoded_messages, foreign_key: :contract_uuid

  def validate_abi
    self.abi = JSON.parse(self.abi) unless self.abi.is_a?(Hash)
  rescue TypeError
    errors.add(:abi, "Should be a valid JSON")
  end
end

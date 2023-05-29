class Contract < ApplicationRecord
  before_create :validate_abi
  before_save :validate_abi
  enum blockchain: {
    venom: 0,
    everscale: 1
  }

  enum network: {
    devnet: 0,
    mainnet: 1
  }

  def validate_abi
    self.abi = JSON.parse(self.abi) unless self.abi.is_a?(Hash)
  rescue TypeError
    errors.add(:abi, "Should be a valid JSON")
  end
end

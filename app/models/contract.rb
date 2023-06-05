class Contract < ApplicationRecord
  include Blockchainable
  paginates_per 20
  has_many :decoded_messages, foreign_key: :contract_uuid

  enum category: {
    unknown: 0,
    nft: 1,
    dex: 2,
    lending: 3,
    staking: 4,
    farming: 5,
    wallet: 6,
  }

  enum init_population_state: {
    pending: 0,
    queued: 1,
    in_progress: 2,
    done: 3
  }

  after_create :queue_init_population

  validates :name, :abi, :blockchain, :network, :category, presence: true

  validate :correct_network

  validate :abi_is_correct_json

  def abi_is_correct_json
    self.abi = JSON.parse(self.abi) unless self.abi.is_a?(Hash)
  rescue TypeError, JSON::ParserError
    errors.add(:abi, "Should be a valid JSON")
  end

  def correct_network
    if network.present? && blockchain.present? && !network.in?(SUPPORTED_BLOCKCHAINS[blockchain.to_sym])
      errors.add(:network, "#{network.capitalize} is not a valid for #{blockchain.capitalize}, only #{SUPPORTED_BLOCKCHAINS[blockchain.to_sym].map(&:capitalize).join(",")} supported")
    end
  end

  def queue_init_population
    blockchain_module::DecodeMessagesJob.perform_later(contract_ids: [self.id], try_to_decode_all: true)
    update(init_population_state: :queued)
  end

end

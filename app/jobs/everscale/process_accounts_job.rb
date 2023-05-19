module Everscale
  class ProcessAccountsJob < ApplicationJob
    queue_as :accounts

    def perform(address_ids)
      existing_pg_accounts_ids = Account.everscale.mainnet.where(address: address_ids).pluck(:address)
      address_ids.each do |address_id|
        next if existing_pg_accounts_ids.include?(address_id)

        account = Account.create!(
          address: address_id,
          blockchain: :everscale,
          network: :mainnet,
          base_currency: :ever_coin
        )

        Everscale::RetrieveAccountStateJob.perform_later(account.id)
      end
    end
  end
end

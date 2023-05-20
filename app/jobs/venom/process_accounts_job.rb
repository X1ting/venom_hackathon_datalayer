module Venom
  class ProcessAccountsJob < ApplicationJob
    queue_as :accounts

    def perform(address_ids)
      existing_pg_accounts_ids = Account.venom.devnet.where(address: address_ids).pluck(:address)
      address_ids.each do |address_id|
        next if existing_pg_accounts_ids.include?(address_id)

        account = Account.create!(
          address: address_id,
          blockchain: :venom,
          network: :devnet,
          base_currency: :venom_coin
        )

        Venom::RetrieveAccountStateJob.perform_later(account.id)
      end
    end
  end
end

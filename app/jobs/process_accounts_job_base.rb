class ProcessAccountsJobBase < ApplicationJob
  queue_as :accounts

  def perform(address_ids)
    existing_pg_accounts_ids = account_base.where(address: address_ids).pluck(:address)
    address_ids.each do |address_id|
      next if existing_pg_accounts_ids.include?(address_id)

      account = Account.create!(
        address: address_id,
        blockchain: blockchain,
        network: network,
        base_currency: base_currency
      )

      retrieve_account_state_job.perform_later(account.id)
    end
  end

  def account_base
    raise NotImplementedError.new
  end

  def blockchain
    raise NotImplementedError.new
  end

  def network
    raise NotImplementedError.new
  end

  def base_currency
    raise NotImplementedError.new
  end

  def retrieve_account_state_job
    raise NotImplementedError.new
  end
end

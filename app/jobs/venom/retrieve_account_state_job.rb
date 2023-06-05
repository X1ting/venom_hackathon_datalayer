module Venom
  class RetrieveAccountStateJob < SidekiqJob
    sidekiq_options :queue => :accounts

    def perform(account_id)
      account = Account.find(account_id)
      data = JRPC::Venom::Devnet.get_contract_state(account.address)
      if data["result"] && data["result"]["type"] == "exists"
        account.update(
          latest_full_state: data["result"],
          latest_full_state_updated_at: DateTime.now
        )
      end
    end
  end
end

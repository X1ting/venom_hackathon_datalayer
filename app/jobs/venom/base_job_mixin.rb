module Venom
  module BaseJobMixin
    def account_base
      Account.venom.devnet
    end

    def contract_base
      Contract.venom.devnet
    end

    def blockchain
      :venom
    end

    def network
      :devnet
    end

    def base_currency
      :venom_coin
    end

    def retrieve_account_state_job
      Venom::RetrieveAccountStateJob
    end

    def process_account_job
      Venom::ProcessAccountsJob
    end

    def ch_module
      Clickhouse::Venom::Devnet
    end

    def rpc_host
      Rails.application.credentials[Rails.env.to_sym][:venom][:devnet][:host]
    end
  end
end

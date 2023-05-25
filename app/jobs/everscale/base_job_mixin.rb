module Everscale
  module BaseJobMixin
    def account_base
      Account.everscale.mainnet
    end

    def blockchain
      :everscale
    end

    def network
      :mainnet
    end

    def base_currency
      :ever_coin
    end

    def retrieve_account_state_job
      Everscale::RetrieveAccountStateJob
    end

    def ch_module
      Clickhouse::Everscale::Mainnet
    end
  end
end

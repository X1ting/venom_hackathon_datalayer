module Venom
  module BaseJobMixin
    def account_base
      Account.venom.devnet
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
  end
end

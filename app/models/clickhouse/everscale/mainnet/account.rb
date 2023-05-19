module Clickhouse
  module Everscale
    module Mainnet
      class Account < Clickhouse::ApplicationRecord
        self.table_name = 'ton_accounts'

      end
    end
  end
end

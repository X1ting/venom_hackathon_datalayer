module Clickhouse
  module Everscale
    module Mainnet
      class Transaction < Clickhouse::ApplicationRecord
        self.table_name = 'ton_transactions'

      end
    end
  end
end

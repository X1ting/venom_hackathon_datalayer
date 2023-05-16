module Clickhouse
  module Venom
    module Devnet
      class Transaction < Clickhouse::ApplicationRecord
        self.table_name = 'venom_dev_transactions'

      end
    end
  end
end

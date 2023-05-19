module Clickhouse
  module Venom
    module Devnet
      class Transaction < Clickhouse::ApplicationRecord
        self.table_name = 'venom_dev_transactions'


        def messages
          Message.where(transaction_id: id)
        end
      end
    end
  end
end

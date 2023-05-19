module Clickhouse
  module Venom
    module Devnet
      class Message < Clickhouse::ApplicationRecord
        self.table_name = 'venom_dev_messages'

        def transaction
          Transaction.where(id: transaction_id)
        end
      end
    end
  end
end

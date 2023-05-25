module Clickhouse
  module Everscale
    module Mainnet
      class Message < Clickhouse::ApplicationRecord
        self.table_name = 'ton_messages'

        def transaction
          Transaction.where(id: transaction_id)
        end
      end
    end
  end
end

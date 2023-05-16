module Clickhouse
  module Venom
    module DevNet
      class Account < Clickhouse::ApplicationRecord
        self.table_name = 'venom_dev_accounts'

      end
    end
  end
end

module JRPC
  class Client
    include HTTParty

    class << self
      def get_contract_state(address)
        body_data = {
          "jsonrpc" => "2.0",
          "method" => "getContractState",
          "params" => {
            "address" => address
          },
          "id" => 1
        }
        post("/rpc", body: body_data.to_json, headers: { 'Content-Type' => 'application/json' })
      end

      def hosts_config
        Rails.application.credentials[Rails.env.to_sym]
      end
    end
  end
end

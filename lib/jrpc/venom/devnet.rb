module JRPC
  module Venom
    class Devnet < Client
      base_uri "http://#{hosts_config[:venom][:devnet][:host]}:8081"
    end
  end
end


module JRPC
  module Everscale
    class Mainnet < Client
      base_uri "http://#{hosts_config[:everscale][:mainnet][:host]}:8081"
    end
  end
end


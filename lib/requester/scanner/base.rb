module Requester
  module Scanner
    class Base
      include HTTParty

      class << self
        def contracts_list(page:, per_page:)
          body = {
            limit: per_page,
            offset: page * per_page
          }
          post("/info/list", body: body.to_json, headers: { 'Content-Type' => 'application/json' })
        end
      end
    end
  end
end

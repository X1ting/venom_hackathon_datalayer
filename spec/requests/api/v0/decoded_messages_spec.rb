require 'swagger_helper'

RSpec.describe 'api/v0/decoded_messages', type: :request do

  path '/api/v0/decoded_messages' do
    get('list decoded_messages') do
      tags 'Events'
      let(:name) { 'Test' }
      let(:category) { Contract.categories.keys.sample }
      let(:page) { 1 }
      let(:since) { '23.01.2023' }
      let(:until) { '23.01.2023' }
      let(:blockchain) { 'venom' }
      let(:contract_uuid) { 'Test' }
      let(:with_account) { 'Test' }

      parameter name: :category, in: :query, type: :string, description: "Contract category: #{Contract.categories.keys.join(",")}"
      parameter name: :name, in: :query, type: :string, description: 'Event name, e.g. nftCreated'
      parameter name: :page, in: :query, type: :string, description: 'Page'
      parameter name: :since, in: :query, type: :string, description: 'Since date e.g. 26.05.2023'
      parameter name: :until, in: :query, type: :string, description: 'Until date e.g. 26.05.2023'
      parameter name: :blockchain, in: :query, type: :string, description: "Blockchain: #{DecodedMessage.blockchains.keys.join(", ")}"
      parameter name: :contract_uuid, in: :query, type: :string, description: 'Contract UUID'
      parameter name: :with_account, in: :query, type: :string, description: 'Account address'

      response(200, 'successful') do
        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end
    end
  end
end

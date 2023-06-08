require 'swagger_helper'

RSpec.describe 'api/v0/contracts', type: :request do

  path '/api/v0/contracts' do
    get('list contracts') do
      let(:name) { 'Test' }
      let(:category) { Contract.categories.keys.sample }
      let(:page) { 1 }

      parameter name: :category, in: :query, type: :string, description: "Contract category: #{Contract.categories.keys.join(",")}"
      parameter name: :name, in: :query, type: :string, description: 'Contract name'
      parameter name: :page, in: :query, type: :string, description: 'Page'

      tags 'Contracts'

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

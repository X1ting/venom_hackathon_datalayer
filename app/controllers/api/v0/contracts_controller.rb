module Api
  module V0
    class ContractsController < ApiController
      def index
        scope = Contract.all

        if params[:name]
          scope = scope.where("contracts.name ILIKE ?", "%#{params[:name]}%")
        end

        if params[:category]
          scope = scope.where(category: params[:category].downcase)
        end

        scope = scope.page(params[:page])
        options = {
          :meta => pagination_options(scope)
        }

        render json: ContractSerializer.new(scope, options).serializable_hash
      end
    end
  end
end

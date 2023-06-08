module Api
  module V0
    class DecodedMessagesController < ApiController
      def index
        scope = DecodedMessage.all

        if params[:since].present?
          scope = scope.where(ext_created_at: Date.parse(params[:since])..)
        end

        if params[:until].present?
          scope = scope.where(ext_created_at: ..Date.parse(params[:until]))
        end

        if params[:blockchain].present?
          scope = scope.where(blockchain: params[:blockchain])
        end

        if params[:contract_uuid].present?
          scope = scope.where(contract_uuid: params[:contract_uuid])
        end

        if params[:with_account].present?
          scope = scope.where(src: params[:with_account]).or(scope.where(dst: params[:with_account]))
        end

        if params[:name].present?
          scope = scope.where(name: params[:name])
        end

        if params[:category].present?
          contract_uuids = Contract.where(category: params[:category].downcase).select(:id)
          scope = scope.where(contract_uuid: contract_uuids)
        end

        scope = scope.order(ext_created_at: :desc).page(params[:page])
        options = {
          :meta => pagination_options(scope)
        }

        render json: DecodedMessageSerializer.new(scope, options).serializable_hash
      end
    end
  end
end

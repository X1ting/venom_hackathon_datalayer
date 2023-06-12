class InsightsController < ApplicationController
  include ContractsHelper

  def index
    params[:since] = (Date.today - 1.day).to_s if params[:since].blank?
    params[:until] = Date.today.to_s if params[:until].blank?

    redirect_to insights_path, notice: "Since date is invalid" and return unless valid_date?(params[:since])
    redirect_to insights_path, notice: "Until date is invalid" and return unless valid_date?(params[:until])

    if params[:since].present?
      @transactions = Transaction.where(time: Date.parse(params[:since])..)
      @accounts = Account.where(created_at: Date.parse(params[:since])..)
      @events = DecodedMessage.where(ext_created_at: Date.parse(params[:since])..)
    end

    if params[:until].present?
      @transactions = Transaction.where(time: ..Date.parse(params[:until]))
      @accounts = Account.where(created_at: ..Date.parse(params[:until]))
      @events = DecodedMessage.where(ext_created_at: ..Date.parse(params[:until]))
    end

    @transactions_insights = Rails.cache.fetch("/index#transactions_insights?#{params}", expires_in: 20.minutes) do
      [
        {
          name: 'Venom',
          data: @transactions.venom.devnet.group_by_minute(:time, n: 5).count
        },
        {
          name: 'Everscale',
          data: @transactions.everscale.mainnet.group_by_minute(:time, n: 5).count
        }
      ]
    end

    @accounts_insights = Rails.cache.fetch("/index#accounts_insights?#{params}", expires_in: 20.minutes) do
      [
        {
          name: 'Venom',
          data: @accounts.venom.devnet.group_by_minute(:created_at, n: 5).count
        },
        {
          name: 'Everscale',
          data: @accounts.everscale.mainnet.group_by_minute(:created_at, n: 5).count
        },
        {
          name: 'NFT',
          data: @accounts.nft.group_by_minute(:created_at, n: 5).count
        },
        {
          name: 'Wallets',
          data: @accounts.wallet.group_by_minute(:created_at, n: 5).count
        }
      ]
    end

    @events_insights = Rails.cache.fetch("/index#events_insights?#{params}", expires_in: 20.minutes) do
      @events.pluck(:name).uniq.map do |method_name|
        {
          name: method_name,
          data: @events.where(name: method_name).group_by_minute(:ext_created_at, n: 15).count
        }
      end
    end
  end

  def events
    params[:since] = (Date.today - 1.day).to_s if params[:since].blank?
    params[:until] = (Date.today).to_s if params[:until].blank?

    redirect_to insights_events_path, notice: "Since date is invalid" and return unless valid_date?(params[:since])
    redirect_to insights_events_path, notice: "Until date is invalid" and return unless valid_date?(params[:until])

    scope = DecodedMessage.all

    if params[:since].present?
      scope = scope.where(ext_created_at: Date.parse(params[:since])..)
    else
      scope = scope.where(ext_created_at: 3.hours.ago..)
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

    if params[:from].present?
      scope = scope.where(src: params[:from])
    end

    if params[:to].present?
      scope = scope.where(src: params[:to])
    end

    if params[:with_account].present?
      scope = scope.where(src: params[:with_account]).or(scope.where(dst: params[:with_account]))
    end

    if params[:name].present?
      scope = scope.where(name: params[:name])
    end

    if params[:category].present?
      contract_uuids = Contract.where(category: params[:category]).select(:id)
      scope = scope.where(contract_uuid: contract_uuids)
    end

    contracts = Contract.where(id: scope.select(:contract_uuid).distinct)

    # @events_insights_per_contract = contracts.select(:id, :name).flat_map do |contract|
    #   scope.where(contract_uuid: contract.id).pluck(:name).uniq.map do |method_name|
    #     {
    #       name: "#{format_contract_name(contract.name)}##{method_name}",
    #       data: scope.where(name: method_name).group_by_minute(:ext_created_at, n: 15).count
    #     }
    #   end
    # end

    @events_insights_per_contract = scope.joins(:contract).group('contracts.name, decoded_messages.name').group_by_minute(:ext_created_at, n: 15).count

    @events_insights_per_category = scope.joins(:contract).group('contracts.category').group_by_minute(:ext_created_at, n: 15).count.transform_keys {|key| [Contract.categories.key(key.first).titleize, key.last] }
  end
end

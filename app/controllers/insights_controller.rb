class InsightsController < ApplicationController
  include ContractsHelper

  def index
    params[:since] = (Date.today - 1.day).to_s if params[:since].blank?
    params[:until] = Date.today.to_s if params[:until].blank?

    redirect_to insights_path, notice: "Since date is invalid" and return unless valid_date?(params[:since])
    redirect_to insights_path, notice: "Until date is invalid" and return unless valid_date?(params[:until])
  end

  def events
    params[:since] = (Date.today - 1.day).to_s if params[:since].blank?
    params[:until] = (Date.today).to_s if params[:until].blank?

    redirect_to insights_events_path, notice: "Since date is invalid" and return unless valid_date?(params[:since])
    redirect_to insights_events_path, notice: "Until date is invalid" and return unless valid_date?(params[:until])
  end

  def events_insights_per_contract
    scope = filter_scope(DecodedMessage.all)
    render json: scope.joins(:contract).group('contracts.name, decoded_messages.name').group_by_minute(:ext_created_at, n: 15).count.chart_json
  end

  def events_insights_per_category
    scope = filter_scope(DecodedMessage.all)
    render json: scope.joins(:contract).group('contracts.category').group_by_minute(:ext_created_at, n: 15).count.transform_keys {|key| [Contract.categories.key(key.first).titleize, key.last] }.chart_json
  end

  def transactions
    @transactions = Transaction.all

    if params[:since].present?
      @transactions = @transactions.where(time: Date.parse(params[:since])..)
    end

    if params[:until].present?
      @transactions = @transactions.where(time: ..Date.parse(params[:until]))
    end

    render json: @transactions.group(:blockchain).group_by_minute(:time, n: 30).count.chart_json
  end

  def events_main
    @events = DecodedMessage.all

    if params[:since].present?
      @events = @events.where(ext_created_at: Date.parse(params[:since])..)
    end

    if params[:until].present?
      @events = @events.where(ext_created_at: ..Date.parse(params[:until]))
    end

    render json: @events.group(:name).group_by_minute(:ext_created_at, n: 30).count.chart_json
  end

  def accounts
    @accounts = Account.all
    if params[:since].present?
      @accounts = @accounts.where(created_at: Date.parse(params[:since])..)
    end

    if params[:until].present?
      @accounts = @accounts.where(created_at: ..Date.parse(params[:until]))
    end

    render json: @accounts.group(:blockchain).group_by_minute(:created_at, n: 30).count.chart_json
  end

  def search_params
    params.permit(:since, :until, :blockchain, :contract_uuid, :from, :to, :with_account, :name, :category)
  end

  def filter_scope(init_scope)
    scope = init_scope

    if params[:since].present?
      scope = scope.where(ext_created_at: Date.parse(params[:since])..)
    else
      scope = scope.where(ext_created_at: 1.day.ago..)
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

    scope
  end
end

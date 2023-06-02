class DecodedMessagesController < ApplicationController
  include ContractsHelper
  before_action :set_decoded_message, only: %i[ show edit update destroy ]
  # GET /decoded_messages or /decoded_messages.json
  def index
    redirect_to decoded_messages_path, notice: "Since date is invalid" and return unless valid_date?(params[:since])
    redirect_to decoded_messages_path, notice: "Until date is invalid" and return unless valid_date?(params[:until])

    scope = DecodedMessage
      .left_joins(:contract)
      .joins("LEFT OUTER JOIN accounts as source_accounts ON source_accounts.address = decoded_messages.src")
      .joins("LEFT OUTER JOIN accounts as destination_accounts ON destination_accounts.address = decoded_messages.dst")
      .select('decoded_messages.*, destination_accounts.id as dst_id, source_accounts.id as src_id')

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

    @decoded_messages = scope.order(:ext_created_at).page(params[:page])
  end

  # GET /decoded_messages/1 or /decoded_messages/1.json
  def show
    @decoded_message_insights = [
      {
        name: "#{format_contract_name(@decoded_message.contract.name)}##{@decoded_message.name}",
        data: DecodedMessage.where(name: @decoded_message.name, contract_uuid: @decoded_message.contract_uuid).group_by_minute(:ext_created_at, n: 15).count
      }
    ]
  end

  # GET /decoded_messages/new
  # def new
  #   @decoded_message = DecodedMessage.new
  # end

  # # GET /decoded_messages/1/edit
  # def edit
  # end

  # POST /decoded_messages or /decoded_messages.json
  def create
    @decoded_message = DecodedMessage.new(decoded_message_params)

    respond_to do |format|
      if @decoded_message.save
        format.html { redirect_to decoded_message_url(@decoded_message), notice: "Decoded message was successfully created." }
        format.json { render :show, status: :created, location: @decoded_message }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @decoded_message.errors, status: :unprocessable_entity }
      end
    end
  end

  # # PATCH/PUT /decoded_messages/1 or /decoded_messages/1.json
  # def update
  #   respond_to do |format|
  #     if @decoded_message.update(decoded_message_params)
  #       format.html { redirect_to decoded_message_url(@decoded_message), notice: "Decoded message was successfully updated." }
  #       format.json { render :show, status: :ok, location: @decoded_message }
  #     else
  #       format.html { render :edit, status: :unprocessable_entity }
  #       format.json { render json: @decoded_message.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  # # DELETE /decoded_messages/1 or /decoded_messages/1.json
  # def destroy
  #   @decoded_message.destroy

  #   respond_to do |format|
  #     format.html { redirect_to decoded_messages_url, notice: "Decoded message was successfully destroyed." }
  #     format.json { head :no_content }
  #   end
  # end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_decoded_message
      @decoded_message = DecodedMessage.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def decoded_message_params
      params.require(:decoded_message).permit(:blockchain, :network, :ext_id, :src, :dst, :body_type, :name)
    end
end

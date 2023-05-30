class DecodedMessagesController < ApplicationController
  before_action :set_decoded_message, only: %i[ show edit update destroy ]

  # GET /decoded_messages or /decoded_messages.json
  def index

    @decoded_messages = DecodedMessage
      .left_joins(:contract)
      .joins("LEFT OUTER JOIN accounts as source_accounts ON source_accounts.address = decoded_messages.src")
      .joins("LEFT OUTER JOIN accounts as destination_accounts ON destination_accounts.address = decoded_messages.dst")
      .select('decoded_messages.*, destination_accounts.id as dst_id, source_accounts.id as src_id')
      .order(:ext_created_at)
      .page(params[:page])

  end

  # GET /decoded_messages/1 or /decoded_messages/1.json
  def show
  end

  # GET /decoded_messages/new
  def new
    @decoded_message = DecodedMessage.new
  end

  # GET /decoded_messages/1/edit
  def edit
  end

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

  # PATCH/PUT /decoded_messages/1 or /decoded_messages/1.json
  def update
    respond_to do |format|
      if @decoded_message.update(decoded_message_params)
        format.html { redirect_to decoded_message_url(@decoded_message), notice: "Decoded message was successfully updated." }
        format.json { render :show, status: :ok, location: @decoded_message }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @decoded_message.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /decoded_messages/1 or /decoded_messages/1.json
  def destroy
    @decoded_message.destroy

    respond_to do |format|
      format.html { redirect_to decoded_messages_url, notice: "Decoded message was successfully destroyed." }
      format.json { head :no_content }
    end
  end

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
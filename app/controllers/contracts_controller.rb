class ContractsController < ApplicationController
  before_action :set_contract, only: %i[ show edit update destroy ]

  # GET /contracts or /contracts.json
  def index
    scope = Contract.all
    if params[:name]
      scope = scope.where("contracts.name ILIKE ?", "%#{params[:name]}%")
    end
    @contracts = scope
      .left_joins(:decoded_messages)
      .select('contracts.*, coalesce(count(decoded_messages.contract_uuid), 0) as messages_count')
      .group('contracts.id')
      .order(messages_count: :desc)
      .page(params[:page])
  end

  # GET /contracts/1 or /contracts/1.json
  def show
    unless @contract.decoded_messages.count.zero?
      @contract_insights = @contract.decoded_messages.pluck(:name).uniq.map do |method_name|
        {
          name: method_name,
          data: @contract.decoded_messages.where(name: method_name).group_by_minute(:ext_created_at, n: 15).count
        }
      end
    end
  end

  # GET /contracts/new
  def new
    @contract = Contract.new
  end

  # GET /contracts/1/edit
  def edit
  end

  # POST /contracts or /contracts.json
  def create
    @contract = Contract.new(contract_params)

    respond_to do |format|
      if @contract.save
        format.html { redirect_to contract_url(@contract), notice: "Contract was successfully created." }
        format.json { render :show, status: :created, location: @contract }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @contract.errors, status: :unprocessable_entity }
      end
    end
  end

  # # PATCH/PUT /contracts/1 or /contracts/1.json
  # def update
  #   respond_to do |format|
  #     if @contract.update(contract_params)
  #       format.html { redirect_to contract_url(@contract), notice: "Contract was successfully updated." }
  #       format.json { render :show, status: :ok, location: @contract }
  #     else
  #       format.html { render :edit, status: :unprocessable_entity }
  #       format.json { render json: @contract.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  # # DELETE /contracts/1 or /contracts/1.json
  # def destroy
  #   @contract.destroy

  #   respond_to do |format|
  #     format.html { redirect_to contracts_url, notice: "Contract was successfully destroyed." }
  #     format.json { head :no_content }
  #   end
  # end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_contract
      @contract = Contract.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def contract_params
      params.require(:contract).permit(:contract_name, :project_link, :tvc, :code_hash, :compiler_version, :linker_version, :blockchain, :network, :abi, :sources)
    end
end

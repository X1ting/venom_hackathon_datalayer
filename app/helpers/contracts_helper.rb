module ContractsHelper
  def format_name(contract_name)
    contract_name&.split("/")&.last
  end
end

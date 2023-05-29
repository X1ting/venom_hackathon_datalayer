json.extract! contract, :id, :contract_name, :project_link, :tvc, :code_hash, :compiler_version, :linker_version, :blockchain, :network, :created_at, :updated_at
json.url contract_url(contract, format: :json)

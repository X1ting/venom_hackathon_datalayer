class ContractSerializer
  include JSONAPI::Serializer
  attributes :name, :project_link, :tvc, :code_hash, :compiler_version, :linker_version, :blockchain, :network, :abi, :sources, :uploaded_by, :category, :init_population_state
end

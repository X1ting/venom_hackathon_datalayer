module Seeder
  class Contracts
    def self.seed_venom_contracts!
      per_page = 30
      page = 0
      first_response = Requester::Scanner::Venom::Devnet.contracts_list(page: 0, per_page: 1)
      total_amount = first_response["total_count"]

      while (page * per_page) < total_amount do
        response = Requester::Scanner::Venom::Devnet.contracts_list(page: page, per_page: per_page)
        response["data"].each do |data|
          create_venom_contract!(data)
        end
        page +=1
      end
    end


    def self.create_venom_contract!(data)
      create_contract!(data, "venom", "devnet", Requester::Scanner::Venom::Devnet.base_uri)
    end

    def self.create_contract!(data, blockchain, network, uploaded_by)
      puts "Contract with name: #{data["contract_name"]} exists!" && return if data["contract_name"].in?(Contract.all.pluck(:name))
      puts "Contract with abi: #{data["abi"]} exists!" && return if data["abi"].in?(Contract.all.pluck(:abi))
      Contract.create!(
        name: data["contract_name"],
        abi: data["abi"],
        project_link: data["project_link"],
        sources: data["sources"],
        tvc: data["tvc"],
        code_hash: data["code_hash"],
        compiler_version: data["compiler_version"],
        linker_version: data["linker_version"],
        blockchain: blockchain,
        network: network,
        uploaded_by: uploaded_by
      )
    end
  end
end

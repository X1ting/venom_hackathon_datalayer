class AnalyzeAccountJob < SidekiqJob
  sidekiq_options :queue => :accounts

  def perform(account_id)
    @account = Account.find(account_id)
    if account.latest_full_state.present?
      data = account.latest_full_state["account"]
      data = Base64.decode64(data)

      nft_data = nft_regexp.match(data).to_a.compact


      nft_data.gsub(remove_shit_regexp, '')
    else
      # Venom::RetrieveAccountStateJob.perform_async(account.id)
    end
  end

  def nft_regexp
    /\{(?:[^{}]|(\{(?:[^{}]|(\{(?:[^{}]|())*\}))*\}))*\}/
  end

  def remove_shit_regexp
    /\\\w{3}/
  end

  def ch_module
    @account.everscale? ? Clickhouse::Everscale::Mainnet : Clickhouse::Venom::Devnet
  end
end

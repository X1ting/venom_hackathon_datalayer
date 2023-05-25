class TransactionCategorizerJob < ApplicationJob
  queue_as :transaction_categorizer

  def perform(transaction_id)
    @transaction = Transaction.find(transaction_id)

    populate_dev_drop && return if dev_drop?
    populate_funds_transfer && return if funds_transfer?
  end

  def dev_drop?
    ch_transaction.balance_delta_dec == "100000000000" && ch_transaction.outmsg_cnt == 0 && ch_messages.count == 1
  end

  def populate_dev_drop
    @transaction.update(
      kind: Transaction.kinds[:devnet_drop],
      from: ch_messages.first.src,
      to: ch_messages.first.dst,
    )
  end

  def populate_funds_transfer
    in_msg = ch_messages.select { |msg| msg.msg_type == 0 }.first
    @transaction.update(
      kind: Transaction.kinds[:funds_transfer],
      from: in_msg.src,
      to: in_msg.dst,
    )
  end

  def funds_transfer?
    ch_transaction.outmsg_cnt == 1 && ch_messages.count == 2 && ch_messages.pluck(:msg_type).sort == [0,1]
  end

  def ch_transaction
    @ch_transaction ||= ch_module::Transaction.find(@transaction.tx_id)
  end

  def ch_messages
    @ch_messages ||= ch_module::Message.where(transaction_id: @transaction.tx_id)
  end

  def out_msgs
    @out_msgs ||= ch_module::Message.where(id: @ch_transaction.out_msgs)
  end

  def ch_module
    @transaction.everscale? ? Clickhouse::Everscale::Mainnet : Clickhouse::Venom::Devnet
  end
end

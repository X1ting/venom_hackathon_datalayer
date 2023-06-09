class StatusController < ApplicationController

  def transactions
    count = Transaction.where(time: 5.minutes.ago..).count
    if count > 0
      head :ok
    else
      head :not_found
    end
  end
end

class HomeController < ApplicationController
  def index
    @transactions = Transaction.order(time: :desc).limit(20)
  end
end

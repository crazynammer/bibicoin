class TransactionsController < ApplicationController
  def new
  @currentTransaction = Transaction.new
  #0 for buy 1 for sell
  @currentTransaction.transaction_type_id = 0
  @currentTransaction.bibicoinBTCtoTWD = 100
  
  
  end
end

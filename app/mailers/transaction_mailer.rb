class TransactionMailer < ActionMailer::Base
  def transaction_confirmation(transaction)
	@transaction = transaction	
	if transaction.transaction_type_id == 0 then
		transactionTypeText = "Bibicoins Buy Order Confirmation #"
	else 
		transactionTypeText = "Bibicoins Sell Order Confirmation #"
	end
	transactionSubject = transactionTypeText + transaction.id.to_s
	mail(:to => transaction.email, :cc => "bibicoins@gmail.com", :subject => transactionSubject, :from => "bibicoins@gmail.com")
  end
end

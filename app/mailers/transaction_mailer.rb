class TransactionMailer < ActionMailer::Base
  def transaction_confirmation(transaction)
	@transaction = transaction
	transactionSubject = "Transaction #" + transaction.id.to_s + " Confirmation"
	mail(:to => transaction.email, :cc => "bibicoins@gmail.com", :subject => transactionSubject, :from => "bibicoins@gmail.com")
  end
end

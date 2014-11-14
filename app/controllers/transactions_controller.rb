class TransactionsController < ApplicationController
  def new
	#get the admin configs and commission rate constants
  	#@adminConfig = AdminConfig.find(1)
	#update with real limits when admin populated
	@COMM_LIMIT_1 = 1
	@COMM_LIMIT_2 = 5
	
	
	
  
	@transaction = Transaction.new
	#0 for buy 1 for sell
	#@transaction.transaction_type_id = 0
	@transaction.transaction_type_id = params[:ttype] 
  #update with real value
	@transaction.bibicoinBTCtoTWD = 400

	
  
  end
  
  def create
	@transaction = Transaction.new(transaction_params)
	if @transaction.save
		flash[:success] = "Transaction successfully saved"
		redirect_to @transaction
		
	else 
		@transaction.errors.each do |attribute, message|
		render 'new'
	end
   end 

  
  def show
	@transaction = Transaction.find(params[:id])
  end
  
  def confirm
	@transaction = Transaction.new(transaction_params)
  end
  
  private
	def transaction_params
		params.require(:transaction).permit(:transaction_type_id, :walletID, :name, :email, :DoB, :TWDAmt, :BTCAmt, :commAmt, :bankName, :bankAcctNumber, :bibicoinBTCtoTWD, :agreeTerms)
	end
end

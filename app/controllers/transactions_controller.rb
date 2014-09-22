class TransactionsController < ApplicationController
  def new
	#get the admin configs and commission rate constants
  	#@adminConfig = AdminConfig.find(1)
	@COMM_LIMIT_1 = 1
	@COMM_LIMIT_2 = 5
	
	
	
  
	@transaction = Transaction.new
	#0 for buy 1 for sell
	@transaction.transaction_type_id = 0
	#@transaction.transaction_type_id = params[:ttype]
	@transaction.bibicoinBTCtoTWD = 100

	
  
  end
  
  def create
	@transaction = Transaction.new(transaction_params)
	if @transaction.save
		redirect_to @transaction
	else 
		#add error message
		render :action => new
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
		params.require(:transaction).permit(:transaction_type_id, :walletID, :name, :email, :DoB, :TWDAmt, :BTCAmt, :bankName, :bankAcctNumber, :bibicoinBTCtoTWD)
	end
end

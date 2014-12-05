class TransactionsController < ApplicationController

require 'nokogiri'
    
respond_to :json
$bitcoinRatesURI = "https://bitpay.com/api/rates"

TWDEXCHANGERATEXML = "http://themoneyconverter.com/rss-feed/TWD/rss.xml"

XCODE_USD = "USD"
XCODE_EUR = "EUR"
XCODE_HKD = "HKD"
XCODE_RMB = "CNY"
HASH_XRATE_CODE = "code"
HASH_XRATE_RATE = "rate"

 
  def new
    #need to add error handling in case the site is down
	response = Net::HTTP.get_response(URI.parse($bitcoinRatesURI))
	exchangeRateRawData = response.body
	  
	#Array to store the required exchange rate information
	@exchangeRateArray = Array.new
	  
	@referenceRateArray = [XCODE_USD, XCODE_EUR, XCODE_HKD, XCODE_RMB]
	  
	#go through each of the reference rate code and find the matching rate hash from the exchange rate raw data
	@rawExchangeRateArray = JSON.parse(exchangeRateRawData)
	for rateCode in @referenceRateArray
		for xrate in @rawExchangeRateArray
			if xrate.fetch(HASH_XRATE_CODE) == rateCode then
				#store the raw hash for now
				#end state is to push the rate to the DB 
				@exchangeRateArray.push(xrate)
			end
		end
	end
	  
	@ratesHash = Hash.new
	for rate in @exchangeRateArray
		@ratesHash[rate.fetch(HASH_XRATE_CODE)] = rate.fetch(HASH_XRATE_RATE)
	end

	#Change all four rates into TWD
	@twdRatesHash = Hash.new
	xml = Nokogiri::XML(open(TWDEXCHANGERATEXML))
	#for each item in the xml
	@twdRates = xml.css('item').each do |item|
		
		#for reference rates
		for rateCode in @referenceRateArray
			#get the exchange rate per 1TWD
			itemDescriptionArray = item.css('description').text.split(' ')
			#get the currency code
			twdCurrencyCode = item.css('title').text[0,3]
			#create a Hashmap with the currency code as the key and the rate per 1TWD as value - will need to store these values to DB
			if twdCurrencyCode == rateCode then
				@twdRatesHash[twdCurrencyCode] = itemDescriptionArray[4]
			end
		end
	end	
		
	totalBTCValue = 0
				
	#get the BTC Value from all four currencies and add them up
	for rateCode in @referenceRateArray
		totalBTCValue = totalBTCValue + (@ratesHash.fetch(rateCode).to_f / @twdRatesHash.fetch(rateCode).to_f)  
	end
		
	#average to get TWD Value for 1 BTC
	@twdValue = totalBTCValue / @referenceRateArray.length

  
	#get the admin configs and commission rate constants
  	#@adminConfig = AdminConfig.find(1)
	#update with real limits when admin populated
	@COMM_LIMIT_1 = 1
	@COMM_LIMIT_2 = 5
		
	#calculate minimum DoB
	todayDate = Date.today
	dobYear = todayDate.year - 18
	dobMonth = todayDate.month
	dobDay = todayDate.day
	@DOB_MIN = Date.new(dobYear, dobMonth, dobDay)
	
  
	@transaction = Transaction.new
	#0 for buy 1 for sell
	#@transaction.transaction_type_id = 0
	@transaction.transaction_type_id = params[:ttype] 
	#BTC to TWD from previously calculated value
	@transaction.bibicoinBTCtoTWD = @twdValue

	
  
  end
  
  def create
	@transaction = Transaction.new(transaction_params)
	@transaction.valid?
#	if verify_recaptcha(:model => @transaction, :message => "Please correct the CAPTCHA entry and try again")
		if @transaction.save
			TransactionMailer.transaction_confirmation(@transaction).deliver
			flash[:success] = "Transaction successfully saved"
			redirect_to @transaction
		else 
			flash[:error] = @transaction.errors.full_messages
			if @transaction.transaction_type_id == 0
				redirect_to :action => "new", :ttype => "0"
			else
				redirect_to :action => "new", :ttype => "1"
			end
		end
		
#	else 
#		flash[:error] = @transaction.errors.full_messages
#		if @transaction.transaction_type_id == 0
#			redirect_to :action => "new", :ttype => "0"
#		else
#			redirect_to :action => "new", :ttype => "1"
#		end
#	end
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

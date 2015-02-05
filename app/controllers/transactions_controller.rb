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
	@COMM_RATE_1 = 0.0625
	@COMM_RATE_2 = 0.0525
	@COMM_RATE_3 = 0.0425
		
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
	
	#list of banks
	@BANKS = 
	[
		[ "Agricultural Bank of Taiwan - 農業金庫" , "Agricultural Bank of Taiwan - 農業金庫" ],
		[ "ANZ Taiwan - 澳盛(台灣)銀行", "ANZ Taiwan - 澳盛(台灣)銀行" ],
		[ "Bank of America - 美國銀行", "Bank of America - 美國銀行" ],
		[ "Bank of East Asia - 東亞銀行", "Bank of East Asia - 東亞銀行" ],
		[ "Bank of Kaohsiung - 高雄銀行", "Bank of Kaohsiung - 高雄銀行" ],
		[ "Bank of Panshin - 板信商業銀行", "Bank of Panshin - 板信商業銀行" ],
		[ "Bank of Taipei - 大台北銀行", "Bank of Taipei - 大台北銀行" ],
		[ "Bank of Taiwan - 臺灣銀行", "Bank of Taiwan - 臺灣銀行" ],
		[ "Bank SinoPac - 永豐銀行", "Bank SinoPac - 永豐銀行" ],
		[ "Cathay United Bank - 國泰世華銀行", "Cathay United Bank - 國泰世華銀行" ],
		[ "Chang Hwa Bank - 彰化銀行", "Chang Hwa Bank - 彰化銀行" ],
		[ "China Development Industrial Bank - 中華開發工銀", "China Development Industrial Bank - 中華開發工銀" ],
		[ "Chinatrust Commercial Bank - 中國信託", "Chinatrust Commercial Bank - 中國信託" ],
		[ "Chunghwa Post - 中華郵政", "Chunghwa Post - 中華郵政" ],
		[ "Citibank Taiwan - 花旗(台灣)銀行", "Citibank Taiwan - 花旗(台灣)銀行" ],
		[ "Cosmos Bank - 萬泰銀行", "Cosmos Bank - 萬泰銀行" ],
		[ "COTA Commercial Bank - 三信商業銀行", "COTA Commercial Bank - 三信商業銀行" ],
		[ "DBS Taiwan - 星展(台灣)銀行", "DBS Taiwan - 星展(台灣)銀行" ],
		[ "Deutsche Bank - 德意志銀行", "Deutsche Bank - 德意志銀行" ],
		[ "E.Sun Bank - 玉山銀行", "E.Sun Bank - 玉山銀行" ],
		[ "EnTie Bank - 安泰商業銀行", "EnTie Bank - 安泰商業銀行" ],
		[ "Far Eastern International Bank - 遠東國際商業銀行", "Far Eastern International Bank - 遠東國際商業銀行" ],
		[ "First Bank - 第一銀行", "First Bank - 第一銀行" ],
		[ "Fubon Financial - 台北富邦銀行", "Fubon Financial - 台北富邦銀行" ],
		[ "HSBC Taiwan - 匯豐(台灣)銀行", "HSBC Taiwan - 匯豐(台灣)銀行" ],
		[ "Hua Nan Bank - 華南銀行", "Hua Nan Bank - 華南銀行" ],
		[ "Hwatai Bank - 華泰銀行", "Hwatai Bank - 華泰銀行" ],
		[ "JihSun Bank - 日盛銀行", "JihSun Bank - 日盛銀行" ],
		[ "King's Town Bank - 京城商銀", "King's Town Bank - 京城商銀" ],
		[ "Land Bank of Taiwan - 土地銀行", "Land Bank of Taiwan - 土地銀行" ],
		[ "Mega International Commercial Bank - 兆豐國際商業銀行", "Mega International Commercial Bank - 兆豐國際商業銀行" ],
		[ "Metrobank - 首都銀行", "Metrobank - 首都銀行" ],
		[ "Shanghai Commercial and Savings Bank - 上海商業儲蓄銀行", "Shanghai Commercial and Savings Bank - 上海商業儲蓄銀行" ],
		[ "Shin Kong Bank - 臺灣新光商銀", "Shin Kong Bank - 臺灣新光商銀" ],
		[ "Standard Chartered - 渣打商銀", "Standard Chartered - 渣打商銀" ],
		[ "Sunny Bank - 陽信銀行", "Sunny Bank - 陽信銀行" ],
		[ "Taichung Bank - 台中商銀", "Taichung Bank - 台中商銀" ],
		[ "Taishin International Bank - 台新銀行", "Taishin International Bank - 台新銀行" ],
		[ "Taiwan Business Bank - 臺灣企銀", "Taiwan Business Bank - 臺灣企銀" ],
		[ "Taiwan Cooperative Bank - 合作金庫銀行", "Taiwan Cooperative Bank - 合作金庫銀行" ],
		[ "TC Bank - 大眾銀行", "TC Bank - 大眾銀行" ],
		[ "Union Bank of Taiwan - 聯邦銀行", "Union Bank of Taiwan - 聯邦銀行" ],
		[ "Yuanta Bank - 元大銀行", "Yuanta Bank - 元大銀行" ]		
	]

	
  
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

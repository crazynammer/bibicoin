class StaticPagesController < ApplicationController

 require 'nokogiri'
  
    respond_to :json
    $bitcoinChartsURI = "https://bitpay.com/api/rates"
	
	
	TWDEXCHANGERATEXML = "http://themoneyconverter.com/rss-feed/TWD/rss.xml"
	
	
 
	XCODE_USD = "USD"
	XCODE_EUR = "EUR"
	XCODE_HKD = "HKD"
	XCODE_RMB = "CNY"
	HASH_XRATE_CODE = "code"
	HASH_XRATE_RATE = "rate"
  
  def home
   #need to add error handling in case the site is down
		response = Net::HTTP.get_response(URI.parse($bitcoinChartsURI))
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
	  
		#TEMPORARY TESTING to store into HASH
		@ratesHash = Hash.new
		for rate in @exchangeRateArray
			@ratesHash[rate.fetch(HASH_XRATE_CODE)] = rate.fetch(HASH_XRATE_RATE)
		end
		#END TEMPORARY
		#render :text => @ratesHash
	  
		
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
		
		#render :text => twdRatesHash
		
		totalBTCValue = 0
				
		#get the BTC Value from all four currencies and add them up
		for rateCode in @referenceRateArray
			totalBTCValue = totalBTCValue + (@ratesHash.fetch(rateCode).to_f / @twdRatesHash.fetch(rateCode).to_f)  
		end
		
		#average to get TWD Value for 1 BTC
		@twdValue = totalBTCValue / @referenceRateArray.length
		
		#render :text =>  twdValue
				
  end

  def contact
  end
  
  def about
  end
  
  def reviews
  end  
  
  def news
  end

  def wallets
  end
  
  def why
  end
  
  def legal
  end    
  
  def privacy
  end
  
  def faq
  end
  
  def jobs
  end
  
  def howtosell
  end
  
  def howtobuy
  end
  
  def sell
  end
  
  def buy
  end
  
  def terms
  end
  
  def bibicoin
  end
  
end

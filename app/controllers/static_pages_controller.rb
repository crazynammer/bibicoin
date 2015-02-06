class StaticPagesController < ApplicationController

 require 'nokogiri'
 require 'rss'
 require 'date'
 require 'gchart'
  
    respond_to :json
    $bitcoinRatesURI = "https://bitpay.com/api/rates"
	$bitcoinStatsURI = "https://blockchain.info/stats?format=json"
	$bitcoinChartsURI = "https://blockchain.info/charts/market-price?format=json"
	
	
	TWDEXCHANGERATEXML = "http://themoneyconverter.com/rss-feed/TWD/rss.xml"
	RSSNEWSFEED = "http://newsbtc.com/feed/"
	
	
 
	XCODE_USD = "USD"
	XCODE_EUR = "EUR"
	XCODE_HKD = "HKD"
	XCODE_RMB = "CNY"
	HASH_XRATE_CODE = "code"
	HASH_XRATE_RATE = "rate"
  
  def home
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
		#buy/sell values for 1BTC + Commission
		@buyValue = @twdValue * 1.0525
		@sellValue = @twdValue * 0.9475
		
		#render :text =>  twdValue
		
		
	
	begin
		#charts section
		chartResponse = Net::HTTP.get_response(URI.parse($bitcoinChartsURI))	
			chartBody = chartResponse.body
		@chartRaw = JSON.parse(chartBody)
		@chartValues = @chartRaw["values"]
		@chartXValues = Array.new
		@chartYValues = Array.new
		for value in @chartValues
			@chartXValues.push(Time.at(value["x"]))
			@chartYValues.push(value["y"])
		end
			
		#render the chart - need to figure out how to dynamically size the charts
		@marketValueChart = Gchart.line(:width => 750, :height => 400, :grid_lines => (100/(@chartYValues.max+100))*100, :data => @chartYValues, :title => 'BTC Market Value (USD)', :axis_with_labels => [['y']], :max_value => @chartYValues.max + 100, :min_value => 0)
	rescue JSON::JSONError => e
		@chartError = "Could not generate USD vs BTC trend chart"
	end
		
	begin	
		#rss section
		@rssNewsFeed = RSS::Parser.parse(RSSNEWSFEED, false).items[0..4]
	rescue RSS::Error => e
		@feedError = "RSS Error with the Newsfeed"
	rescue SocketError => e
		@feedError = "Could not connect to Bitcoin News Feed"
	rescue HTTPError => e
		@feedError = "Could not reach Bitcoin News Feed"
	end
	
	begin
		#statistic info
		statsResponse = Net::HTTP.get_response(URI.parse($bitcoinStatsURI))
		statsBody = statsResponse.body
		@statsRaw = JSON.parse(statsBody)
		@statsHash = Hash.new
		#populate the stats hash with legible values
		
		@statsDateTime = DateTime.now.in_time_zone("Taipei")
		
		@statsHash.store("Blocked Mined", @statsRaw["n_blocks_mined"].round(2).to_s)
		@statsHash.store("Time Between Blocks", @statsRaw["minutes_between_blocks"].round(2).to_s + " minutes")
		@statsHash.store("Bitcoins Mined", (@statsRaw["n_btc_mined"] / 100000000).to_s + " BTC")
		@statsHash.store("Total Transaction Fees", (@statsRaw["total_fees_btc"].to_f / 100000000).round(2).to_s + " BTC")
		@statsHash.store("Number of Transactions", @statsRaw["n_tx"].to_s)
		@statsHash.store("Total Output Volume", (@statsRaw["total_btc_sent"].to_f / 100000000).to_s + " BTC")
		@statsHash.store("Estimated Transaction Volume", (@statsRaw["estimated_btc_sent"].to_f / 100000000).to_s + " BTC")
		@statsHash.store("Estimated Transaction Volume (USD)", "$" + @statsRaw["estimated_transaction_volume_usd"].round(2).to_s)
	
		@statsHash.store("Market Price (USD)", "$" + @statsRaw["market_price_usd"].to_s)
		@statsHash.store("Trade Volume (USD)", "$" + @statsRaw["trade_volume_usd"].round(2).to_s)
		@statsHash.store("Trade Volume", @statsRaw["trade_volume_btc"].round(2).to_s + " BTC")
	
		@statsHash.store("Total Miners Revenue (USD)", "$" + @statsRaw["miners_revenue_usd"].round(2).to_s)
	
		@statsHash.store("Difficulty", @statsRaw["difficulty"].round(2).to_s)
		@statsHash.store("Hash Rate", @statsRaw["hash_rate"].to_s + " GH/s")
				
	rescue JSON::JSONError => e
		@statsError = "Could not retrieve bitcoin network data"
	end
	

	#example of json raw
=begin
["market_price_usd", 397.11] 
["hash_rate", 271437319.7991543] 
["total_fees_btc", 1318454998] 
["n_btc_mined", 390000000000] 
["n_tx", 78460] 
["n_blocks_mined", 156] 
["minutes_between_blocks", 9.230769230769232] 
["totalbc", 1337165000000000] 
["n_blocks_total", 325211] 
["trade_volume_usd", 10355479.510351954] 
["estimated_transaction_volume_usd", 70166033.5973468] 
["blocks_size", 46171311] 
["miners_revenue_usd", 1553891.4300000002] 
["nextretarget", 326591] 
["difficulty", 35002482026.13323] 
["trade_volume_btc", 26077.10586576] 
["estimated_btc_sent", 17669168139142] 
["miners_revenue_btc", 3913] 
["days_destroyed", 0.0] 
["total_btc_sent", 78438104183790] 
["timestamp", 1413240242465] 
=end

	
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

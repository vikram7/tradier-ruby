class TradierApi

  def self.stock_quote(underlying)
    uri = URI.parse("https://sandbox.tradier.com/v1/markets/quotes?symbols=#{underlying}")
    http = Net::HTTP.new(uri.host, uri.port)
    http.read_timeout = 30
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_PEER
    request = Net::HTTP::Get.new(uri.request_uri)
    # Headers
    request["Accept"] = "application/json"
    request["Authorization"] = "Bearer " + ENV["TOKEN"]
    # Send synchronously
    underlying_price = http.request(request)
    underlying_price = JSON.parse(underlying_price.body)["quotes"]["quote"]["last"]
  end

  def self.option_chain(underlying, expiration)
    uri = URI.parse("https://sandbox.tradier.com/v1/markets/options/chains?symbol=#{underlying}&expiration=2014-11-7")
    http = Net::HTTP.new(uri.host, uri.port)
    http.read_timeout = 30
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_PEER
    request = Net::HTTP::Get.new(uri.request_uri)
    # Headers
    request["Accept"] = "application/json"
    request["Authorization"] = "Bearer " + ENV["TOKEN"]
    # Send synchronously
    response = http.request(request)
    readable = JSON.parse(response.body)
    readable = readable["options"]["option"]

    readable.each do |option|
      option["midpoint"] = (option["bid"] + option["ask"]) / 2
      option["timestamp"] = Time.now
    end
  end
end

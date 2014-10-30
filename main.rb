require 'uri'
require 'net/https'
require 'json'
require 'pry'
require_relative 'tradier_api'

time = Time.now
  all_data = []
  securities = [['vxx', '2014-11-14'],
                ['msft', '2014-11-14'],
                ['aapl', '2014-11-14'],
                ['isrg', '2014-11-14'],
                ['v', '2014-11-14'],
                ['crm', '2014-11-14'],
                ['vmw', '2014-11-14'],
                ['spy', '2014-11-14'],
                ['googl', '2014-11-14'],
                ['bmy', '2014-11-14'],
                ['vxx', '2014-11-14']]


def some(sec, array)
  underlying_price = TradierApi.stock_quote(sec.first)
  chain = TradierApi.option_chain(sec.first, sec.last)
  chain.each do |option|
    option['underlying_price'] = underlying_price
  end
  array << chain
end

# securities.each do |sec|
#   all_data << some(sec)
# end
threads = (0...securites.length).map do |i|
  Thread.new(i) do |i|
    some(securities[i], all_data)
  end
end

threads.each do |thread|
  thread.join
end

puts Time.now - time

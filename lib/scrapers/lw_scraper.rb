#!/usr/bin/env ruby

require_relative "./scraper"

class LwScraper < Scraper
	def exchange_rates(opts={})
		url = 'https://liderwalut.pl/json/currency.json'

		res = {
			exchange_rates: [],
			source: 'lw',
			update_at: nil,
			scrape_at: nil
		}

		page = @agent.get(url)

		data = JSON.parse(page.body)

		data['feed'].each do |el|
			rate = {}

			currency = el['currency_name']
			pair = [currency, 'PLN'].join('_')

			rate[:pair] = pair
			rate[:buying_rate] = el['cf_bid'].to_s
			rate[:selling_rate] = el['cf_ask'].to_s

			rate[:average_rate] = calculate_average_rate(rate[:buying_rate], rate[:selling_rate])

			res[:exchange_rates] << rate
		end

		res[:update_at] = data['feed'].map {|el| Time.parse(el['date'])}.uniq.max.strftime("%F %H:%M:%S")
		res[:scrape_at] = Time.now.strftime("%F %H:%M:%S")

		res
	end
end

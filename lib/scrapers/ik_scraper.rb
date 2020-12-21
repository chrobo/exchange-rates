#!/usr/bin/env ruby

require_relative "./scraper"

class IkScraper < Scraper
	def exchange_rates(opts={})
		url = 'https://internetowykantor.pl/cms/currency/'

		res = {
			exchange_rates: [],
			source: 'ik',
			update_at: nil,
			scrape_at: nil
		}

		page = @agent.get(url)

		data = JSON.parse(page.body)

		data['rates'].each do |key, val|
			rate = {}

			currency = key
			pair = [currency, 'PLN'].join('_')

			rate[:pair] = pair
			rate[:buying_rate] = val['buying_rate']
			rate[:selling_rate] = val['selling_rate']
			rate[:average_rate] = val['average_rate']

			res[:exchange_rates] << rate
		end

		res[:update_at] = data['last_update']
		res[:scrape_at] = Time.now.strftime("%F %H:%M:%S")

		res
	end
end

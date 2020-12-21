#!/usr/bin/env ruby

require_relative "./scraper"

class KoScraper < Scraper
	def exchange_rates(opts={})
		url = 'https://kantoronline.pl/kursy-walut'

		res = {
			exchange_rates: [],
			source: 'ko',
			update_at: nil,
			scrape_at: nil
		}

		page = @agent.get(url)

		doc = page.parser

		update_times = []		

		doc.css('#tableofcurrency tr').each do |tr|
			rate = {}

			update_times << extract_text(tr, 'td[id^="time"]')

			currency = extract_text(tr, '.bold')
			rate[:pair] = [currency, 'PLN'].join('_')

			rate[:buying_rate] = extract_price(tr, 'td[id$="sell"]')
			rate[:selling_rate] = extract_price(tr, 'td[id$="buy"]')

			rate[:average_rate] = calculate_average_rate(rate[:buying_rate], rate[:selling_rate])

			res[:exchange_rates] << rate
		end

		res[:update_at] = update_times.map {|el| Time.parse(el)}.uniq.max.strftime("%F %H:%M:%S")
		res[:scrape_at] = Time.now.strftime("%F %H:%M:%S")

		res
	end
end

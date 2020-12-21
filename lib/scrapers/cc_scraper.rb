#!/usr/bin/env ruby

require_relative "./scraper"

class CcScraper < Scraper
	def exchange_rates(opts={})
		url = 'https://cinkciarz.pl/wa/pe/transactional?subscriptionId=PLN&unit=10'

		res = {
			exchange_rates: [],
			source: 'cc',
			update_at: nil,
			scrape_at: nil
		}

		page = @agent.get(url)

		doc = Nokogiri::HTML(page.body, url, "UTF-8") do |config|
			config.nonet.huge
		end

		doc.css('table tbody > tr').each do |tr|
			rate = {}

			rate[:pair] = extract_text(tr, 'td:first-child > a[href*="kursy-walut"]').gsub(/\s+/, '_')

			rate[:buying_rate] = extract_price(tr, 'td[data-buy] span:not([class])')
			rate[:selling_rate] = extract_price(tr, 'td[data-sell] span:not([class])')

			rate[:average_rate] = calculate_average_rate(rate[:buying_rate], rate[:selling_rate])

			res[:exchange_rates] << rate
		end

		res[:update_at] = res[:scrape_at] = Time.now.strftime("%F %H:%M:%S")

		res
	end
end

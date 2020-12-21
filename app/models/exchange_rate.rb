class ExchangeRate < ApplicationRecord
	# validations
	validates_presence_of :source, :base_currency, :foreign_currency, :buying_rate, :selling_rate, :average_rate, :refreshed_at

	# sources:
	# https://cinkciarz.pl/
	scope :cc, -> { where(source: 'cc') }
	# https://internetowykantor.pl/
	scope :ik, -> { where(source: 'ik') }
	# https://kantoronline.pl/
	scope :ko, -> { where(source: 'ko') }
	# https://liderwalut.pl/
	scope :lw, -> { where(source: 'lw') }

	def self.currencies_fetch!(log=nil, *services)
		log ||= Rails.logger

		# services to scrape
		svcs = services.blank? ? supported_scrapers : services

		svcs.each do |service|
			scraper_class = Object.const_get "#{service.capitalize}Scraper"
			log.info("Get scraper: #{scraper_class} for service: #{service}")

			# load scraper class
			scraper = scraper_class.new

			# scrape results
			res = scraper.exchange_rates()

			source = res[:source]
			scrape_date = Time.parse(res[:scrape_at])

			# list of exchange rates
			rates = res[:exchange_rates]

			rates.each do |rate|
				log.info("Process results for exchange rate: #{rate}")

				f_curr, b_curr = rate[:pair].split('_')

				er = {
					source: source,
					base_currency: b_curr,
					foreign_currency: f_curr,
					buying_rate: BigDecimal(rate[:buying_rate]),
					selling_rate: BigDecimal(rate[:selling_rate]),
					average_rate: BigDecimal(rate[:average_rate]),
					refreshed_at: scrape_date
				}

				log.info("Create ExchangeRate: #{er}")
				er = ExchangeRate.create!(er)
			end
		end
	end

	def self.supported_scrapers
		[:cc, :ik, :ko, :lw]
	end

	def self.currency_list
		[
			"EUR", "USD", "CHF", "GBP",
			"AED", "AUD", "BGN", "CAD",
			"CNY", "CZK", "DKK", "HKD",
			"HRK", "HUF", "ILS", "JPY",
			"LTL", "MXN", "NOK", "NZD",
			"RON", "RSD", "RUB", "SEK",
			"SGD", "THB", "TRY", "ZAR"
		]
	end
end

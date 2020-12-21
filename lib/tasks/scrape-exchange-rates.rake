namespace :rates do
	desc "scrape exchange rates"
	task :fetch_services => :environment do
		log = Logger.new(STDOUT)

		log.info("Start scrape exchange rates for all services")
		ExchangeRate.currencies_fetch!(log)
		log.info("Finished exchange rates scraping")
	end

	desc "remove old rates"
	task :remove_old_data => :environment do
		log = Logger.new(STDOUT)

		log.info("Start removing old exchange rates")
		ExchangeRate.where("refreshed_at < (NOW() - '2.5 hours'::interval)").find_each {|er| er.destroy}
		log.info("Finished removing old exchange rates")
	end
end

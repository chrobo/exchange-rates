#!/usr/bin/env ruby

require 'pry'
require 'awesome_print'

# run scrape: bundle exec ruby ./lib/scrapers/scraper_fetch.rb ex-rates lw
# choose scraper name: cc, ik, ko, lw
if ARGV.size < 2
	puts "To run scrape use command with scraper name:

		bundle exec ruby ./lib/scrapers/scraper_fetch.rb ex-rates [cc|ik|ko|lw]

		for exaple:

		bundle exec ruby ./lib/scrapers/scraper_fetch.rb ex-rates cc
		bundle exec ruby ./lib/scrapers/scraper_fetch.rb ex-rates lw"

	exit 1
end

scr_name = ARGV.last

require_relative "./#{scr_name}_scraper"

# choose scraper type
scr = Kernel.const_get("#{scr_name.capitalize}Scraper").new
log = Logger.new(STDOUT).tap {|x| x.level = Logger::INFO }

if ARGV.include?("ex-rates")
	# get all exchange rates for current service
	res = scr.exchange_rates(logger: log)
end

ap res

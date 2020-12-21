#!/usr/bin/env ruby

require 'active_support/core_ext/object/blank'
require 'bigdecimal'
require 'mechanize'
require 'awesome_print'
require 'logger'
require 'pry'
require 'json'

class Scraper
	attr_accessor :log

	def initialize(opts={})
		@log = Logger.new(STDOUT)
		@log.level = Logger::INFO

		original_formatter = Logger::Formatter.new
		@log.formatter = proc { |severity, datetime, progname, msg|
			original_formatter.call(severity, datetime, progname, msg.dump)
		}

		@agent = Mechanize.new
		@agent.user_agent = 'Mozilla/5.0 (X11; Linux x86_64; rv:85.0) Gecko/20100101 Firefox/85.0'
		@agent.log = @log

		@agent.keep_alive = false
	end

	def extract_text(doc, css_sel)
		txt = doc.css(css_sel).first.text.strip

		txt.present? ? txt : nil
	end

	def extract_price(doc, css_sel)
		price = extract_text(doc, css_sel)

		price.present? ? price.gsub(',', '.') : nil
	end

	def calculate_average_rate(buy_rate, sel_rate)
		buy = BigDecimal(buy_rate)
		sel = BigDecimal(sel_rate)
		avr = ( (buy + sel) / 2 ).round(4).to_f.to_s

		if avr.size < 6
			diff = 6 - avr.size
			diff.times { avr << "0" }
		end

		avr
	end
end

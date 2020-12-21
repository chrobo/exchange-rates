FactoryBot.define do
	factory :exchange_rate do
		source { Faker::Lorem.word }
		base_currency { Faker::Currency.code }
		foreign_currency { Faker::Currency.code }
		buying_rate { Faker::Number.decimal(l_digits: 1, r_digits: 4) }
		selling_rate { Faker::Number.decimal(l_digits: 1, r_digits: 4) }
		average_rate { Faker::Number.decimal(l_digits: 1, r_digits: 4) }
		refreshed_at { Faker::Time.between(from: DateTime.now - 1, to: DateTime.now) }
	end
end

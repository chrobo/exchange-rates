class ExchangeRateSerializer < ActiveModel::Serializer
  attributes :id, :source, :base_currency, :foreign_currency, :buying_rate, :selling_rate, :average_rate, :refreshed_at
end

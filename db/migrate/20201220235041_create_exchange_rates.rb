class CreateExchangeRates < ActiveRecord::Migration[5.2]
  def change
    create_table :exchange_rates do |t|
      t.string :source, null: false
      t.string :base_currency, null: false
      t.string :foreign_currency, null: false
      t.decimal :buying_rate, null: false, precision: 20, scale: 10
      t.decimal :selling_rate, null: false, precision: 20, scale: 10
      t.decimal :average_rate, null: false, precision: 20, scale: 10
      t.timestamp :refreshed_at, null: false

      t.timestamps
    end
  end
end

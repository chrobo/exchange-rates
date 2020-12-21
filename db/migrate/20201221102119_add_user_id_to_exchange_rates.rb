class AddUserIdToExchangeRates < ActiveRecord::Migration[5.2]
  def change
  	add_column :exchange_rates, :user_id, :integer
  end
end

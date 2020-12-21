require 'rails_helper'

RSpec.describe ExchangeRate, type: :model do
	# validation test
	# ensure columns are present before saving
  it { should validate_presence_of(:source) }
  it { should validate_presence_of(:base_currency) }
  it { should validate_presence_of(:foreign_currency) }
  it { should validate_presence_of(:buying_rate) }
  it { should validate_presence_of(:selling_rate) }
  it { should validate_presence_of(:average_rate) }
  it { should validate_presence_of(:refreshed_at) }
end

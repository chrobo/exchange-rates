class ExchangeRatesController < ApplicationController
  before_action :set_exchange_rate, only: [:show, :update, :destroy]

  # GET /exchange_rates
  def index
    @exchange_rates = current_user.exchange_rates
    json_response(@exchage_rates)
  end

  # POST /exchange_rates
  def create
    @exchage_rate = current_user.exchange_rates.create!(exchange_rate_params)
    json_response(@exchage_rate, :created)
  end

  # GET /exchange_rates/:id
  def show
    json_response(@exchage_rate)
  end

  # PUT /exchange_rates/:id
  def update
    @exchage_rate.update(exchange_rate_params)
    head :no_content
  end

  # DELETE /exchange_rates/:id
  def destroy
    @exchage_rate.destroy
    head :no_content
  end

  private

  def exchange_rate_params
    # whitelist params
    params.permit(
    	:source, :base_currency, :foreign_currency,
    	:buying_rate, :selling_rate, :average_rate,
    	:refreshed_at
    )
  end

  def set_exchange_rate
    @exchage_rate = ExchangeRate.find(params[:id])
  end
end

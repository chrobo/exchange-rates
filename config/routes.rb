Rails.application.routes.draw do
	resources :exchange_rates

	post 'auth/login', to: 'authentication#authenticate'
	post 'signup', to: 'users#create'
end

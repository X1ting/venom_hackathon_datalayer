require 'sidekiq/web'
Rails.application.routes.draw do
  resources :decoded_messages
  Sidekiq::Web.use(Rack::Auth::Basic) do |username, password|
    ActiveSupport::SecurityUtils.secure_compare(::Digest::SHA256.hexdigest(username), ::Digest::SHA256.hexdigest(Rails.application.credentials[Rails.env.to_sym][:sidekiqweb][:username])) &
      ActiveSupport::SecurityUtils.secure_compare(::Digest::SHA256.hexdigest(password), ::Digest::SHA256.hexdigest(Rails.application.credentials[Rails.env.to_sym][:sidekiqweb][:password]))
    end

  mount Sidekiq::Web => '/sidekiq'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "insights#index"

  resources :accounts, only: [:index, :show]
  resources :insights, only: :index
  resources :contracts

  get '/search', to: 'search#search'

end

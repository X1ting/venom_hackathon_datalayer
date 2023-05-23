require 'sidekiq/web'
Rails.application.routes.draw do
  Sidekiq::Web.use(Rack::Auth::Basic) do |username, password|
    ActiveSupport::SecurityUtils.secure_compare(::Digest::SHA256.hexdigest(username), ::Digest::SHA256.hexdigest(Rails.application.credentials[Rails.env.to_sym][:sidekiqweb][:username])) &
      ActiveSupport::SecurityUtils.secure_compare(::Digest::SHA256.hexdigest(password), ::Digest::SHA256.hexdigest(Rails.application.credentials[Rails.env.to_sym][:sidekiqweb][:password]))
    end

  mount Sidekiq::Web => '/sidekiq'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "transactions#index"

  resources :accounts, only: [:index, :show]
  resources :insights, only: :index

  get '/search', to: 'search#search'

end

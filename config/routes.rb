require 'sidekiq/web'

Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  Sidekiq::Web.use(Rack::Auth::Basic) do |username, password|
    ActiveSupport::SecurityUtils.secure_compare(::Digest::SHA256.hexdigest(username), ::Digest::SHA256.hexdigest(Rails.application.credentials[Rails.env.to_sym][:sidekiqweb][:username])) &
      ActiveSupport::SecurityUtils.secure_compare(::Digest::SHA256.hexdigest(password), ::Digest::SHA256.hexdigest(Rails.application.credentials[Rails.env.to_sym][:sidekiqweb][:password]))
    end

  mount Sidekiq::Web => '/sidekiq'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "insights#index"

  resources :decoded_messages, only: [:index, :show]
  resources :transactions, only: :index
  resources :accounts, only: [:index, :show]
  resources :insights, only: :index do
    get :events, on: :collection
  end
  resources :contracts

  get '/search', to: 'search#search'

  namespace :api do
    namespace :v0 do
      resources :contracts, only: :index
      resources :decoded_messages, only: :index
    end
  end
  resources :status, only: [] do
    get :transactions, on: :collection
  end
end

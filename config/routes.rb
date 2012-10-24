Athletetrax::Application.routes.draw do

  scope '/' do
    root :to => 'website/static_pages#home'
  end

  root :to => 'home#index'

  devise_for :users

  resources :home, only: [:index]
  scope :home, :controller => :home do
    post :reset, as: 'home/reset'
  end

  resources :messages do
    collection do
      get :counters
      get :mark_all_read
    end
  end
  resources :recipients, :only => [:index]

  #routings error
  match '*a', :to => 'errors#routing_error'
end

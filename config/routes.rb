Rails.application.routes.draw do
    resources :users, param: :_email
    post '/auth/login', to: 'authentication#login'
    
    get 'users/new'
    
    get 'favorites', to: 'bills#index'

    get 'proposal/:ext_id', to: 'bills#new'
end

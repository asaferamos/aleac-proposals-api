Rails.application.routes.draw do
  get 'users/new'
  
  get 'favorites', to: 'bills#index'

  get 'proposal/:ext_id', to: 'bills#new'
end

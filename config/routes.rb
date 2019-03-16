Rails.application.routes.draw do
    resources :users, param: :_email
    post '/auth/login', to: 'authentication#login'
    
    get 'users/new'
    
    get 'favorites', to: 'bills#index'

	get    'proposal/', 	   to: 'bills#index'
	get    'proposal/:ext_id', to: 'bills#new'
	post   'proposal/:ext_id', to: 'bills#create'
	delete 'proposal/:ext_id', to: 'bills#destroy'
end

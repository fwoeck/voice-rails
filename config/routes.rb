Rails.application.routes.draw do

  devise_for :users, path: 'auth', path_names: {
    sign_in: 'login',
    sign_out: 'logout'
  }, controllers: { sessions: 'sessions' }

  root 'application#index'

  get 'calls'     => 'calls#index'
  get 'users'     => 'users#index'
  get 'users/:id' => 'users#show'
  put 'users/:id' => 'users#update'

  get '*path', to: 'application#catch_404'
end

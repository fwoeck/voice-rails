Rails.application.routes.draw do

  devise_for :users, path: 'auth', path_names: {
    sign_in: 'login', sign_out: 'logout'
  }, controllers: { sessions: 'sessions' }

  root   'application#index'
  get    'stats'               => 'application#index'
  get    'datasets'            => 'stats#index'

  get    'calls'               => 'calls#index'
  post   'calls'               => 'calls#originate'
  delete 'calls/:id'           => 'calls#hangup'
  post   'calls/:id/transfer'  => 'calls#transfer'

  post   'chat_messages'       => 'chat_messages#create'
  get    'chat_messages'       => 'chat_messages#index'

  get    'users'               => 'users#index'
  get    'users/:id'           => 'users#show'
  put    'users/:id'           => 'users#update'

  get    'customers'           => 'customers#index'
  put    'customers/:id'       => 'customers#update'
  get    'customers/:id'       => 'customers#show'
  put    'history_entries/:id' => 'customers#update_history'
  get    'zendesk_tickets'     => 'customers#get_zendesk_tickets'
  post   'zendesk_tickets'     => 'customers#create_zendesk_ticket'

  get    '*path'               => 'application#catch_404'
  post   '*path'               => 'application#catch_404'
end

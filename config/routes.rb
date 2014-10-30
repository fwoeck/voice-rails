Rails.application.routes.draw do

  devise_for :users, path: 'auth', path_names: {
    sign_in: 'login', sign_out: 'logout'
  }, controllers: { sessions: 'sessions' }

  root     'application#index'
  get      'app'                 => 'application#ember_index'
  get      'app/*any'            => 'application#ember_index'

# if Rails.env.development? # TODO Re-enable guard
    get    'seed/agents'         => 'seeds#agents'
    get    'seed/customers'      => 'seeds#customers'
# end

  scope '/api/1' do

    get    'calls'               => 'calls#index'
    post   'calls'               => 'calls#originate'
    delete 'calls/:id'           => 'calls#hangup'
    post   'calls/:id/transfer'  => 'calls#transfer'

    get    'datasets'            => 'stats#index'
    post   'chat_messages'       => 'chat_messages#create'
    get    'chat_messages'       => 'chat_messages#index'

    get    'users'               => 'users#index'
    get    'users/:id'           => 'users#show'
    put    'users/:id'           => 'users#update'
    post   'users'               => 'users#create'

    get    'customers'           => 'customers#index'
    get    'search_results'      => 'customers#index'
    put    'customers/:id'       => 'customers#update'
    get    'customers/:id'       => 'customers#show'
    put    'history_entries/:id' => 'customers#update_history'
    get    'crm_tickets'         => 'customers#get_crm_tickets'
    post   'crm_tickets'         => 'customers#create_crm_ticket'
  end

  get      '*path'               => 'application#catch_404'
  post     '*path'               => 'application#catch_404'
end

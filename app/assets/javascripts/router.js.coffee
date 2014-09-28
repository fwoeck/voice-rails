Voice.Router.map ->
  @resource('customers', path: '/customers')
  @resource('customer',  path: '/customers/:customer_id')

  @resource('agents')
  @resource('stats')


Voice.Router.reopen
  location: 'history'
  rootURL:  '/app'

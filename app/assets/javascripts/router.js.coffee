Voice.Router.map ->
  @resource('customers')
  @resource('agents')
  @resource('stats')


Voice.Router.reopen
  location: 'history'
  rootURL:  '/app'

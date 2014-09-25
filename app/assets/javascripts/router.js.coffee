Voice.Router.map ->
  @resource('agents')
  @resource('custom')
  @resource('stats')


Voice.Router.reopen
  location: 'history'
  rootURL:  '/app'

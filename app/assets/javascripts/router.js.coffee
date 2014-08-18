Voice.Router.map ->
  @resource('agents')
  @resource('stats')


Voice.Router.reopen
  location: 'history'

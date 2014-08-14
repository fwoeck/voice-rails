Voice.Router.map ()->
  @resource('stats')

Voice.Router.reopen
  location: 'history'

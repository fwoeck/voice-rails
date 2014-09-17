app.defaultUserPrefs =
  useWebRtc:        true
  autoLogout:       60
  hideForeignCalls: false


app.getUserPrefs = (uid) ->
  return unless uid
  json = window.localStorage[uid] || JSON.stringify(app.defaultUserPrefs)
  $.extend app.defaultUserPrefs, JSON.parse(json)


app.putUserPrefs = (uid, obj) ->
  window.localStorage[uid] = JSON.stringify(obj)


app.storeLocalKey = (key, value) ->
  uid = Voice.get('currentUser.id')
  return unless uid
  prefs = app.getUserPrefs(uid)
  prefs[key] = value
  app.putUserPrefs(uid, prefs)


app.loadLocalKey = (key) ->
  uid = Voice.get('currentUser.id')
  return unless uid
  app.getUserPrefs(uid)[key]

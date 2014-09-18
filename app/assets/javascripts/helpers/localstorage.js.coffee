app.defaultUserPrefs =
  useWebRtc:        true
  autoLogout:       60
  hideForeignCalls: false


app.getUserPrefs = (uid) ->
  json = window.localStorage[uid] || JSON.stringify(app.defaultUserPrefs)
  $.extend app.defaultUserPrefs, JSON.parse(json)


app.putUserPrefs = (uid, obj) ->
  window.localStorage[uid] = JSON.stringify(obj)


app.storeLocalKey = (key, value) ->
  if (uid = Voice.get 'currentUser.id')
    prefs = app.getUserPrefs(uid)
    prefs[key] = value
    app.putUserPrefs(uid, prefs)


app.loadLocalKey = (key) ->
  if (uid = Voice.get 'currentUser.id')
    app.getUserPrefs(uid)[key]

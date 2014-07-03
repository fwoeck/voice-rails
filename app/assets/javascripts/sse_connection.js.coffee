window.pushMessages = []


window.setupSSE = ->
  return unless env.userId.length > 0
  sseSource = new EventSource("/events?user_id=#{env.userId}&rails_env=#{env.railsEnv}&token=#{env.sessionToken}")


  window.onbeforeunload = ->
    sseSource.close()
    console.log(new Date, 'Closed SSE connection.')


  sseSource.onopen = (event) ->
    console.log(new Date, 'Opened SSE connection.')


  sseSource.onerror = (event) ->
    console.log(new Date, 'SSE connection error', event)
    window.setTimeout window.setupSSE, 1000
    sseSource.close()


  sseSource.onmessage = (event) ->
    data = JSON.parse(event.data)
    window.pushMessages.push(data) unless data.servertime

window.setupSSE = ->
  return unless env.userId

  token     = encodeURI ($ 'meta[name="csrf-token"]').attr('content')
  sseSource = new EventSource("/events?user_id=#{env.userId}&rails_env=#{env.railsEnv}&token=#{token}")


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
    console.log(new Date, data)

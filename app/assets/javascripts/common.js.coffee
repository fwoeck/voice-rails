window.app = {

  noLogin: ->
    env.userId.length == 0


  setupInterface: ->
    ($ '#agent_overview > h5').click ->
      ($ '#call_queue').toggleClass('expanded')

    ($ '#my_settings > h5').click ->
      ($ '#my_settings').toggleClass('expanded')
      ($ '#call_queue').toggleClass('lifted')

    ($ '#call_queue > h5').click ->
      ($ '#call_queue').addClass('expanded').addClass('lifted')
      ($ '#my_settings').removeClass('expanded')

    ($ document).on 'click', '#my_settings label', (el) -> ($ el.target).siblings('input').click()


  setupSSE: ->
    params = "?user_id=#{env.userId}&rails_env=#{env.railsEnv}&token=#{env.sessionToken}"
    sseSource = new EventSource('/events' + params)

    window.onbeforeunload = ->
      sseSource.close()
      console.log(new Date, 'Closed SSE connection.')

    sseSource.onopen = (event) ->
      console.log(new Date, 'Opened SSE connection.')

    sseSource.onerror = (event) ->
      console.log(new Date, 'SSE connection error', event)
      window.setTimeout app.setupSSE, 1000
      sseSource.close()

    sseSource.onmessage = (event) ->
      data = JSON.parse(event.data)
      console.log(data) if env.debug

      if data.user
        Voice.store.pushPayload('user', data)

      if data.call
        Voice.store.pushPayload('call', data)

      if env.railsEnv == 'test'
        env.messages.push(data)
}

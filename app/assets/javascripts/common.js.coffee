window.setupInterface = ->
  return if env.userId.length == 0

  ($ '#agent_overview > h5').click ->
    ($ '#call_queue').toggleClass('expanded')

  ($ '#my_settings > h5').click ->
    ($ '#my_settings').toggleClass('expanded')
    ($ '#call_queue').toggleClass('lifted')

  ($ '#call_queue > h5').click ->
    ($ '#my_settings').removeClass('expanded')
    ($ '#call_queue').addClass('expanded')
    ($ '#call_queue').addClass('lifted')

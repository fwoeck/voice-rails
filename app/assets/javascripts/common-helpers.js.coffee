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

}

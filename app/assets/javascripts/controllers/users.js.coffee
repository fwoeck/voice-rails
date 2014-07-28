Voice.UsersController = Ember.ArrayController.extend({

  availableAgents: (->
    @get('content').filter( (a) ->
      a.get('availability') == 'ready' &&
      a.get('agentState') == 'registered'
    ).length
  ).property('content.@each.{agentState,availability}')


  onlineAgents: (->
    @get('content').filter( (a) ->
      state = a.get('agentState')
      state == 'registered' || state == 'talking'
    ).length
  ).property('content.@each.agentState')
})

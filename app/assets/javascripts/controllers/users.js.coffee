Voice.UsersController = Ember.ArrayController.extend({

  availableAgents: (->
    @get('content').filter( (a) ->
      a.get('availability') == 'ready' &&
      a.get('agentState') == 'registered'
    ).length
  ).property('content.@each.{agentState,availability}')
})

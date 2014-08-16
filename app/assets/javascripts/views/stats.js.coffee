Voice.StatsView = Ember.View.extend({

  dataBinding: 'controller.content.firstObject'


  didInsertElement: ->
    data = @get('data')
    @refreshTimer = window.setInterval (->
      Voice.store.find('dataset').then ->
        data.notifyPropertyChange('queuedCalls')
        data.notifyPropertyChange('dispatchedCalls')
        data.notifyPropertyChange('averageDelay')
        data.notifyPropertyChange('maxDelay')
    ), 3000


  willDestroyElement: ->
    window.clearInterval @refreshTimer
})

Voice.SearchExamplesView = Ember.View.extend({

  templateName: (->
    "search_examples_#{env.locale}"
  ).property()


  willDestroyElement: ->
    Ember.run.cancel(@timer) if @timer


  didInsertElement: ->
    app.resetScrollPanes()
    Ember.run.cancel(@timer) if @timer

    @timer = Ember.run.later @, (->
      ($ '#customer_search_examples').removeClass('hidden')
      @timer = 0
    ), 2000
})

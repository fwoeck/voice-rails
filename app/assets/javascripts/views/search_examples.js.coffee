Voice.SearchExamples = Ember.View.extend({

  templateName: (->
    "search_examples_#{env.locale}"
  ).property()


  willDestroyElement: ->
    Ember.run.cancel(@timer) if @timer


  didInsertElement: ->
    Ember.run.cancel(@timer) if @timer

    @timer = Ember.run.later @, (->
      ($ '#customer_search_examples').removeClass('hidden')
      @timer = 0
    ), 3000
})

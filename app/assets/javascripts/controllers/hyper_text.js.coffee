Voice.HyperTextController = Ember.ObjectController.extend({

  filteredContent: (->
    escaped = Handlebars.Utils.escapeExpression(@get 'model')
    result  = escaped.replace(app.phoneNumber, '$1<span class="link">$2</span>')

    new Ember.Handlebars.SafeString(result)
  ).property('model')
})

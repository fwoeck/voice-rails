Voice.HyperTextView = Ember.View.extend({

  tagName: 'p'


  click: (e) ->
    value = ($ e.target).text()
    @dialOut(value) if value.match(app.phoneNumber)
    false


  dialOut: (value) ->
    number = value.replace(/^\+/, '00').replace(/[^0-9]/g, '')
    app.originateCall(number)
})

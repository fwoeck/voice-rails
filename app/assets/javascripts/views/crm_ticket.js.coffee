Voice.CrmTicketView = Ember.View.extend({

  tagName: 'tr'


  didInsertElement: ->
    app.initFoundation()


  willDestroyElement: ->
    tooltip = @$('span.has-tip').attr('data-selector')
    ($ "span.tooltip[data-selector='#{tooltip}']").remove()
})

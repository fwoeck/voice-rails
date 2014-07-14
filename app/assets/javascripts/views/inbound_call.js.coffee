Voice.InboundCallView = Ember.View.extend({

  didInsertElement: ->
    @$().foundation()


  willDestroyElement: ->
    tooltip = @$('span.has-tip').attr('data-selector')
    ($ "span.tooltip[data-selector='#{tooltip}']").remove()

})

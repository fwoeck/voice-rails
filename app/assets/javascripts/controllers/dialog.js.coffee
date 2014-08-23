Voice.DialogController = Ember.ObjectController.extend {

  modelBinding: 'Voice.dialogContent'

  actions:
    noop: ->
      false

    cancelDialog: ->
      @cancel()

    acceptDialog: ->
      return false if @anyErrors()
      @accept()


  init: ->
    @_super()
    Voice.dialogController = @


  unfocus: ->
    app.focusDefaultTabindex()


  isActive: ( ->
    !!@get('model.message')
  ).property('model.message')


  anyErrors: ->
    ($ '#dialog_wrapper small.error:visible').length > 0


  cancel: ->
    @clear()

    reject = @get('model.reject')
    if typeof reject == 'function'
      Ember.run @, reject


  accept: ->
    resolve = @get('model.resolve')
    if typeof resolve == 'function'
      @resolvePromise(resolve)
    else
      @clear()


  resolvePromise: (resolve) ->
    if @get('requiresInput')
      text = @get 'text'

      if @inputIsValid(text)
        @clear()
        Ember.run @, resolve, text
    else
      @clear()
      Ember.run @, resolve


  inputIsValid: (text) ->
    (text && text.length > 0) || @get('inputIsOptional')


  clear: ->
    model = @get 'model'
    return unless model

    model.set 'message', null
    model.set 'text',    null


  requiresDecision: ( ->
    type = @get('model.type')
    type == 'question' || type == 'dialog'
  ).property('model.type')


  requiresInput: ( ->
    @get('model.type') == 'dialog'
  ).property('model.type')


  inputIsOptional: ( ->
    @get('model.format') == 'optional'
  ).property('model.format')


  validatesNumber: ( ->
    @get('model.format') == 'number'
  ).property('model.format')


  placeholderNumber: (->
    i18n.placeholder.type_a_number
  ).property()


  placeholderOptional: (->
    i18n.placeholder.optional_text
  ).property()


  placeholderHere: (->
    i18n.placeholder.type_here
  ).property()
}

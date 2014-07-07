Voice.User = DS.Model.extend({
  email:         DS.attr 'string'
  roles:         DS.attr 'string'
  skills:        DS.attr 'string'
  fullname:      DS.attr 'string'
  languages:     DS.attr 'string'
  availability:  DS.attr 'string'
})

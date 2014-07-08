Voice.SkillSettings = Ember.Mixin.create({

  splitSkills: ( ->
    Ember.keys(env.skills).forEach (skill) =>
      key = "skill#{skill.toUpperCase()}"
      val = @skillIsSet(skill)
      @set(key, val) if @get(key) != val
  ).observes('skills')


  skillIsSet: (skill) ->
    !!@get('skills').match(skill)


  joinSkills: ->
    newSkills = []
    Ember.keys(env.skills).forEach (skill) =>
      key = "skill#{skill.toUpperCase()}"
      newSkills.push(skill) if @get(key)

    newVal = newSkills.sort().join(',')
    @set('skills', newVal) if newVal != @get('skills')


  observeSkills: ( ->
    Ember.run.scheduleOnce 'actions', @, @joinSkills
  ).observes(
    'skillOFFERS', 'skillBILLING', 'skillBOOKING',
    'skillOTHER'
  )
})

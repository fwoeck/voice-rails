Voice.SkillSettings = Ember.Mixin.create({

  splitSkills: ( ->
    Ember.keys(env.skills).forEach (skill) =>
      key = "skill#{skill.toUpperCase()}"
      val = @skillIsSet(skill)
      @set(key, val) if @get(key) != val
  ).observes('skills.[]')


  skillIsSet: (skill) ->
    @get('skills').indexOf(skill) > -1


  joinSkills: ->
    newSkills = []
    Ember.keys(env.skills).forEach (skill) =>
      key = "skill#{skill.toUpperCase()}"
      newSkills.push(skill) if @get(key)

    newVal = newSkills.sort()
    @set('skills', newVal) if Ember.compare(newVal, @get 'skills')


  observeSkills: ->
    self = @
    Ember.keys(env.skills).forEach (skill) =>
      key = "skill#{skill.toUpperCase()}"
      @addObserver(key, -> Ember.run.scheduleOnce 'actions', self, self.joinSkills)
})

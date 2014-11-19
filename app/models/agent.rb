class Agent

  attr_accessor :id, :name, :languages, :skills, :activity, :visibility, :call_id,
                :locked, :availability, :idle_since, :mutex, :unlock_scheduled


  def handle_message
    if (user = User.where(name: name).first)
      user.send_user_update_to_clients
    end
  end


  def language=(langs)
    @languages = langs
  end


  def skill=(skills)
    @skills = skills
  end


  class << self

    LOCALES = WimConfig.ui_locales
    SKILLS  = WimConfig.skills.keys
    LANGS   = WimConfig.languages.keys


    def create_fake
      User.create_from(fake_attributes Faker::Name.name)
    end


    def fake_attributes(fn)
      { full_name:    fn,
        roles:        ['agent'],
        password:     'P4ssw0rd',
        confirmation: 'P4ssw0rd',
        email:        email_for(fn),
        locale:       LOCALES.sample,
        languages:    samples_for(LANGS),
        skills:       samples_for(SKILLS)
      }
    end


    def email_for(fn)
      fn.downcase.gsub(' ', '-').gsub(/[.']/, '') + '@mail.com'
    end


    def samples_for(pool)
      pool.sample(1 + rand(3))
    end
  end
end

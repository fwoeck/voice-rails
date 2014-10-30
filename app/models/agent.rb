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

    def create_fake
    # raise unless Rails.env.development?
      fn = Faker::Name.name

      User.create_from(
        full_name:    fn,
        roles:        ['agent'],
        password:     'P4ssw0rd',
        confirmation: 'P4ssw0rd',
        email:        email_for(fn),
        languages:    samples_for(:langs),
        skills:       samples_for(:skills)
      )
    end


    def email_for(fn)
      fn.downcase.gsub(' ', '-').gsub(/[.']/, '') + '@mail.com'
    end


    def samples_for(sym)
      [send(sym).next, send(sym).next, send(sym).next].sample(1 + rand(3))
    end


    def langs
      @memo_langs ||= WimConfig.languages.keys.cycle
    end


    def skills
      @memo_skills ||= WimConfig.skills.keys.cycle
    end
  end
end

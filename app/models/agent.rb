class Agent

  attr_accessor :id, :name, :languages, :skills, :activity, :visibility, :call_id,
                :locked, :availability, :idle_since, :mutex, :unlock_scheduled


  def handle_message
    VoiceThread.async {
      if user = User.where(name: name).first
        user.send_user_update_to_clients
      end
    }
  end


  def language=(langs)
    @languages = langs
  end


  def skill=(skills)
    @skills = skills
  end


  class << self

    def create_fake
      raise unless Rails.env.development?

      User.create_from(
        roles:        ['agent'],
        password:     'P4ssw0rd',
        confirmation: 'P4ssw0rd',
        languages:    samples_for(:langs),
        skills:       samples_for(:skills),
        full_name:    (fn = Faker::Name.name),
        email:        fn.downcase.gsub(' ', '-') + '@mail.com'
      )
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

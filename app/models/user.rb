class User < ActiveRecord::Base

  # The "type" field is being used by asterisk for friend/peer:
  self.inheritance_column = :_type_disabled

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :roles
  has_many :skills
  has_many :languages

  include UpdateFields


  def update_attributes_from(params)
    update_availability_from(params)
    update_languages_from(params)
    update_skills_from(params)
    update_fields_from(params)
  end


  def send_update_notification_to_clients
    User.all.each do |user|
      AmqpManager.push_publish(
        user_id: user.id, data: UserSerializer.new(self)
      )
    end
  end


  def role_summary
    roles.map(&:name).sort.join(',')
  end

  def skill_summary
    skills.map(&:name).sort.join(',')
  end

  def language_summary
    languages.map(&:name).sort.join(',')
  end

  private


  def notify_ahn_about_update(key)
    self.reload
    return if Rails.env.test?

    AmqpManager.ahn_publish({
      user_id: self.id,
      key   => send("#{key}_summary")
    })
  end
end

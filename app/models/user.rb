class User < ActiveRecord::Base
  self.inheritance_column = :_type_disabled

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  attr_reader :availability

  has_many :roles
  has_many :skills
  has_many :languages


  def set_language(_key)
    key = _key.to_s
    check_for_language_validity(key)
    languages.find_or_create_by(name: key)
    notify_ahn_about_update(:language)
  end

  def unset_language(_key)
    key = _key.to_s
    check_for_language_validity(key)
    languages.find_by(name: key).try(:delete)
    notify_ahn_about_update(:language)
  end


  def set_role(_key)
    key = _key.to_s
    check_for_role_validity(key)
    roles.find_or_create_by(name: key)
    notify_ahn_about_update(:role)
  end

  def unset_role(_key)
    key = _key.to_s
    check_for_role_validity(key)
    roles.find_by(name: key).try(:delete)
    notify_ahn_about_update(:role)
  end


  def set_skill(_key)
    key = _key.to_s
    check_for_skill_validity(key)
    skills.find_or_create_by(name: key)
    notify_ahn_about_update(:skill)
  end

  def unset_skill(_key)
    key = _key.to_s
    check_for_skill_validity(key)
    skills.find_by(name: key).try(:delete)
    notify_ahn_about_update(:skill)
  end


  def role_summary
    roles.map(&:name).join(',')
  end

  def skill_summary
    skills.map(&:name).join(',')
  end

  def language_summary
    languages.map(&:name).join(',')
  end


  private


  def notify_ahn_about_update(key)
    reload
    AmqpManager.ahn_publish user_id: self.id, key => send("#{key}_summary")
  end


  def check_for_language_validity(key)
    unless WimConfig.languages.keys.include?(key)
      raise "Invalid user language. Use any of #{WimConfig.languages.keys.join(',')}"
    end
  end

  def check_for_role_validity(key)
    unless WimConfig.roles.keys.include?(key)
      raise "Invalid user role. Use any of #{WimConfig.roles.keys.join(',')}"
    end
  end

  def check_for_skill_validity(key)
    unless WimConfig.skills.keys.include?(key)
      raise "Invalid user skill. Use any of #{WimConfig.skills.keys.join(',')}"
    end
  end
end

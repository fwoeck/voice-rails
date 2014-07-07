class User < ActiveRecord::Base

  # The "type" field is being used by asterisk for friend/peer:
  self.inheritance_column = :_type_disabled

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :roles
  has_many :skills
  has_many :languages


  def update_attributes_from(params)
    update_availability_from(params)
    update_languages_from(params)
    update_skills_from(params)
    send_update_notification_to_clients
  end


  def set_availability(key)
    check_for_validity(:availability, key)
    $redis.set(availability_keyname, key, ex: availability_ttl)
    notify_ahn_about_update(:availability)
  end

  def availability
    $redis.get(availability_keyname) || 'unknown'
  end
  alias :availability_summary :availability


  def set_language(key)
    set_field(:language, key)
  end

  def unset_language(key)
    unset_field(:language, key)
  end


  def set_role(key)
    set_field(:role, key)
  end

  def unset_role(key)
    unset_field(:role, key)
  end


  def set_skill(key)
    set_field(:skill, key)
  end

  def unset_skill(key)
    unset_field(:skill, key)
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


  def set_field(field, _key)
    key = _key.to_s
    check_for_validity(field, key)
    self.send("#{field}s").find_or_create_by(name: key)
    notify_ahn_about_update(field)
  end


  def unset_field(field, _key)
    key = _key.to_s
    check_for_validity(field, key)
    self.send("#{field}s").find_by(name: key).try(:delete)
    notify_ahn_about_update(field)
  end


  def check_for_validity(field, key)
    keys = WimConfig.send("#{field}#{field[/y\z/] ? '' : 's'}").keys
    unless keys.include?(key)
      raise "Invalid user #{field} - use any of #{keys.join(',')}"
    end
  end


  def notify_ahn_about_update(key)
    self.reload
    AmqpManager.ahn_publish({
      user_id: self.id,
      key   => send("#{key}_summary")
    })
  end


  def availability_keyname
    "#{Rails.env}.availability.#{self.id}"
  end

  def availability_ttl
    1.day
  end


  def update_availability_from(params)
    _availability = params[:user].fetch(:availability, availability)
    if _availability != availability
      set_availability(_availability)
    end
  end

  def update_languages_from(params)
    old_langs = languages.map(&:name).sort
    new_langs = params[:user].fetch(:languages).split(',').sort

    if old_langs != new_langs
      (old_langs - new_langs).each { |l| unset_language(l) }
      (new_langs - old_langs).each { |l| set_language(l) }
    end
  end

  def update_skills_from(params)
    old_skills = skills.map(&:name).sort
    new_skills = params[:user].fetch(:skills).split(',').sort

    if old_skills != new_skills
      (old_skills - new_skills).each { |l| unset_skill(l) }
      (new_skills - old_skills).each { |l| set_skill(l) }
    end
  end

  def send_update_notification_to_clients
    User.all.each do |user|
      AmqpManager.push_publish(
        user_id: user.id, data: UserSerializer.new(self)
      )
    end
  end
end

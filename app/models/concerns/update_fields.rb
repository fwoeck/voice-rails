module UpdateFields
  extend ActiveSupport::Concern


  def set_availability(key)
    check_for_validity(:availability, key)
    $redis.set(availability_keyname, key, ex: 1.day)
    notify_ahn_about_update(:availability)
  end


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


  def availability_keyname
    "#{Rails.env}.availability.#{self.id}"
  end

  def callstate_keyname
    "#{Rails.env}.callstate.#{self.id}"
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


  def update_fields_from(params)
    self.fullname = params[:user].fetch(:fullname, fullname)
    save!
  end
end

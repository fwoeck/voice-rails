module UpdateFields
  extend ActiveSupport::Concern


  def update_roles_from(p, as_admin=false)
    old_roles = roles.map(&:name).sort
    new_roles = fetch_blank(p, :roles).split(',').sort
    new_roles = (['admin'] + new_roles).uniq if as_admin

    if old_roles != new_roles
      (old_roles - new_roles).each { |r| remove_role(r.to_sym) }
      (new_roles - old_roles).each { |r| add_role(r.to_sym) }
    end
  end


  def set_availability(key)
    check_for_validity(:availability, key)
    Redis.current.set(availability_keyname, key)

    @memo_availability = nil
    notify_ahn_about_update(:availability)
  end


  def set_language(key)
    set_field(:language, key)
  end

  def unset_language(key)
    unset_field(:language, key)
  end


  def set_skill(key)
    set_field(:skill, key)
  end

  def unset_skill(key)
    unset_field(:skill, key)
  end


  def availability_keyname
    "#{Rails.env}.availability.#{self.id}"
  end

  def activity_keyname
    "#{Rails.env}.activity.#{self.id}"
  end

  def visibility_keyname
    "#{Rails.env}.visibility.#{self.id}"
  end

  def token_keyname
    "#{Rails.env}.token.#{self.id}"
  end

  private


  def set_field(field, _key)
    key = _key.to_s
    check_for_validity(field, key)

    self.send("#{field}s").find_or_create_by(name: key)
    self.reload
    notify_ahn_about_update(field)
  end


  def unset_field(field, _key)
    key = _key.to_s
    check_for_validity(field, key)

    self.send("#{field}s").find_by(name: key).try(:delete)
    self.reload
    notify_ahn_about_update(field)
  end


  def check_for_validity(field, key)
    keys = WimConfig.send("#{field}#{field[/y\z/] ? '' : 's'}").keys
    unless keys.include?(key)
      raise "Invalid user #{field} #{key} - use any of #{keys.join(',')}"
    end
  end


  def update_availability_from(p)
    new_avail = p.fetch(:availability, availability)
    if !new_avail.blank? && new_avail != availability
      set_availability(new_avail)
    end
  end


  def update_languages_from(p)
    old_langs = languages.map(&:name).sort
    new_langs = fetch_blank(p, :languages).split(',').sort

    if old_langs != new_langs
      (old_langs - new_langs).each { |l| unset_language(l) }
      (new_langs - old_langs).each { |l| set_language(l) }
    end
  end


  def update_skills_from(p)
    old_skills = skills.map(&:name).sort
    new_skills = fetch_blank(p, :skills).split(',').sort

    if old_skills != new_skills
      (old_skills - new_skills).each { |s| unset_skill(s) }
      (new_skills - old_skills).each { |s| set_skill(s) }
    end
  end


  def update_fields_from(p)
    self.name       = p.fetch(:name,       name)
    self.fullname   = p.fetch(:fullname,   fullname)
    self.zendesk_id = p.fetch(:zendesk_id, zendesk_id)

    self.secret     = p[:secret] unless p[:secret].blank?
    self.password   = p[:password] unless p[:password].blank?
    self.password_confirmation = p[:confirmation] unless p[:confirmation].blank?

    save!
  end


  def fetch_blank(hash, name)
    hash.fetch(name, "") || ""
  end
end

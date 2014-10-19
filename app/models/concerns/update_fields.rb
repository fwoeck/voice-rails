module UpdateFields
  extend ActiveSupport::Concern


  def update_roles_from(p, as_admin=false)
    old_roles = roles.map(&:name).sort
    new_roles = (p[:roles] || []).sort
    new_roles = (['admin'] + new_roles).uniq if as_admin

    sync_roles_with(old_roles, new_roles)
  end


  def update_attributes_from(p)
    update_availability_from(p)
    update_languages_from(p)
    update_skills_from(p)
    update_fields_from(p)
  end


  def set_availability(key)
    check_for_validity(:availability, key)
    RPool.with { |con| con.set(availability_keyname, key) }

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


  private

  def sync_roles_with(old_roles, new_roles)
    return if old_roles == new_roles

    (old_roles - new_roles).each { |r| remove_role(r.to_sym) }
    (new_roles - old_roles).each { |r| add_role(r.to_sym) }
  end


  def set_field(field, key)
    update_field(:sadd, field, key)
  end


  def unset_field(field, key)
    update_field(:srem, field, key)
  end


  def update_field(sym, field, _key)
    key = _key.to_s
    check_for_validity(field, key)

    RPool.with { |con| con.send(sym, keyname_for(field), key) }
    instance_variable_set("@memo_#{field}s", nil)
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
    update_field_from(p, :language)
  end


  def update_skills_from(p)
    update_field_from(p, :skill)
  end


  def update_field_from(p, field)
    fields = "#{field}s".to_sym
    old_f  = self.send(fields)
    new_f  = (p[fields] || []).sort

    sync_field_with(old_f, new_f, field)
  end


  def sync_field_with(old_f, new_f, field)
    return if old_f == new_f

    (old_f - new_f).each { |f| self.send("unset_#{field}", f) }
    (new_f - old_f).each { |f| self.send(  "set_#{field}", f) }
  end


  def update_fields_from(p)
    [:name, :locale, :full_name, :crmuser_id].each { |sym|
      bulk_update(sym, p)
    }

    update_passwords(p)
    save!
  end


  def update_passwords(p)
    self.secret   = p[:secret]   unless p[:secret].blank?
    self.password = p[:password] unless p[:password].blank?
    self.password_confirmation = p[:confirmation] unless p[:confirmation].blank?
  end


  def bulk_update(sym, p)
    self.send "#{sym}=", p.fetch(sym, self.send(sym))
  end
end

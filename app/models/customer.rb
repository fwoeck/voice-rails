class Customer

  include Mongoid::Document

  field :fullname,   type: String,   default: ""
  field :email,      type: String,   default: ""
  field :caller_ids, type: Array,    default: -> { [] }
  field :zendesk_id, type: String,   default: ""
  field :created_at, type: DateTime, default: -> { Time.now.utc }

  embeds_many :history_entries

  index(caller_ids: 1)


  def manage_zendesk_account(par_zendesk_id)
    if par_zendesk_id == '...' # FIXME This is ugly.
      request_zendesk_id
    elsif zendesk_id.blank? && !par_zendesk_id.blank?
      self.zendesk_id = par_zendesk_id
      fetch_zendesk_user
    elsif !zendesk_id.blank?
      update_zendesk_record
    end
  end

  private


  def fetch_zendesk_user
    if (user = $zendesk.users.find id: zendesk_id)
      self.fullname = user.name
      self.email    = user.email
    end
  end


  def update_zendesk_record
    VoiceThread.run {
      user = $zendesk.users.find(id: zendesk_id)

      if zendesk_needs_update?(user)
        user.name    = fullname
        user.phone ||= caller_ids.first
        user.email   = email
        user.save
      end
    }
  end


  def zendesk_needs_update?(user)
    return unless user
    user.name != fullname || user.email != email ||
      user.phone != caller_ids.first
  end


  def request_zendesk_id
    unless fullname.blank?
      opts         = {name: fullname}
      opts[:email] = email unless email.blank?
      opts[:phone] = caller_ids.first

      user = $zendesk.users.create(opts)
      self.zendesk_id = user.id.to_s if user
    end
  end
end

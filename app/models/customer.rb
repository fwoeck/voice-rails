class Customer

  include Mongoid::Document

  field :email,      type: String,   default: ""
  field :full_name,  type: String,   default: ""
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
      self.full_name = user.name
      self.email     = user.email
    end
  end


  def update_zendesk_record
    VoiceThread.run {
      user = $zendesk.users.find(id: zendesk_id)

      if zendesk_needs_update?(user)
        user.name    = full_name
        user.phone ||= caller_ids.first
        user.email   = email
        user.save
      end
    }
  end


  def zendesk_needs_update?(user)
    return unless user
    user.name != full_name || user.email != email ||
      user.phone != caller_ids.first
  end


  def request_zendesk_id
    unless full_name.blank?
      opts         = {name: full_name}
      opts[:email] = email unless email.blank?
      opts[:phone] = caller_ids.first

      user = $zendesk.users.create(opts)
      self.zendesk_id = user.id.to_s if user
    end
  end
end

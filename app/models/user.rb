class User < ActiveRecord::Base

  # The "type" field is being used by asterisk for friend/peer:
  self.inheritance_column = :_type_disabled

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  rolify

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
    AmqpManager.push_publish(
      user_ids: User.all_online_ids, data: UserSerializer.new(self)
    )
  end


  def availability
    @memo_availability ||= ($redis.get(availability_keyname) || 'unknown')
  end
  alias :availability_summary :availability


  def activity
    @memo_activity ||= ($redis.get(activity_keyname) || 'silent')
  end


  def visibility
    @memo_visibility ||= ($redis.get(visibility_keyname) || 'offline')
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


  # TODO This requires too many redis-requests.
  #      We should cache this information from the incoming
  #      amqp-messages:
  #
  def self.all_online_ids
    $redis.keys(Rails.env + '.visibility.*')
          .map { |key| [key[/\d+$/], $redis.get(key)] }
          .select { |s| s[1] == 'online' }
          .map { |s| s[0].to_i }
  end


  # Caution, this is used by the external chef provisioning:
  #
  def self.seed_admin_user
    u = User.where(email: WimConfig.admin_email).first_or_initialize
    return if u.has_role?(:admin)

    u.add_role(:admin)
    update_admin_user(u)
    # TODO send SIGHUP to Ahn
  end


  def self.update_admin_user(u)
    u.name                  = WimConfig.admin_name
    u.email                 = WimConfig.admin_email
    u.secret                = WimConfig.admin_secret
    u.fullname              = WimConfig.admin_fullname
    u.password              = WimConfig.admin_password
    u.password_confirmation = WimConfig.admin_password
    u.save
  end


  private

  def notify_ahn_about_update(key)
    self.reload
    return if Rails.env.test?

    AmqpManager.ahn_publish(
      user_id: self.id,
      key   => send("#{key}_summary")
    )
  end
end

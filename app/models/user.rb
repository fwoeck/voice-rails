class User < ActiveRecord::Base

  # The "type" field is being used by asterisk for friend/peer:
  self.inheritance_column = :_type_disabled

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  rolify

  has_many :skills
  has_many :languages

  include UpdateFields

  before_save   :send_ahn_notification
  after_create  :notify_ahn_about_update
  after_destroy :notify_ahn_about_update


  validates :name,       numericality: {only_integer: true},
                         length: { is: 3 },
                         allow_blank: true,
                         uniqueness: true

  validates :secret,     numericality: {only_integer: true},
                         allow_blank: true

  validates :email,      presence: true,
                         uniqueness: true,
                         email: true

  validates :zendesk_id, numericality: {only_integer: true},
                         length: { is: 9 },
                         allow_blank: true


  def update_attributes_from(p)
    update_availability_from(p)
    update_languages_from(p)
    update_skills_from(p)
    update_fields_from(p)
  end


  def send_update_notification_to_clients(async=false)
    delay = async ? 0.1 : 0

    VoiceThread.run {
      sleep delay
      AmqpManager.push_publish(
        user_ids: User.all_online_ids, data: UserSerializer.new(self)
      )
    }
  end


  def availability
    @memo_availability ||= (Redis.current.get(availability_keyname) || 'unknown')
  end
  alias :availability_summary :availability


  def activity
    @memo_activity ||= (Redis.current.get(activity_keyname) || 'silent')
  end


  def visibility
    @memo_visibility ||= (Redis.current.get(visibility_keyname) || 'offline')
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


  def set_admin_prefs(c = WimConfig)
    tap { |u|
      u.name     = c.admin_name
      u.email    = c.admin_email
      u.secret   = c.admin_secret
      u.fullname = c.admin_fullname
      u.password = c.admin_password
      u.password_confirmation = c.admin_password
    }.save
  end


  class << self

    # TODO This requires too many redis-requests.
    #      Can we cache this information from the incoming
    #      amqp-messages?
    #
    def all_online_ids
      Redis.current.keys(Rails.env + '.visibility.*')
           .map { |key| [key[/\d+$/], Redis.current.get(key)] }
           .select { |s| s[1] == 'online' }
           .map { |s| s[0].to_i }
    end


    # Caution, this is used by the external chef provisioning:
    #
    def seed_admin_user
      u = User.where(email: WimConfig.admin_email).first_or_initialize
      return if u.has_role?(:admin)

      u.add_role(:admin)
      u.set_admin_prefs
    end


    def build_param_hash(p)
      {
        name:       p.fetch(:name, nil).try(:strip),
        email:      p.fetch(:email).strip.downcase,
        secret:     p.fetch(:secret, nil).try(:strip),
        password:   p.fetch(:password),
        fullname:   p.fetch(:fullname).strip,
        zendesk_id: p.fetch(:zendesk_id, nil).try(:strip),
        password_confirmation: p.fetch(:confirmation)
      }
    end


    def create_from(p)
      sanitize_params(p)
      par  = build_param_hash(p)
      user = User.create!(par)

      user.update_attributes_from(p)
      user.update_roles_from(p)
      user
    end


    def sanitize_params(p)
      [:name, :secret, :zendesk_id].each { |sym|
        p[sym] = nil if p[sym].blank?
      }

      p[:name]   ||= get_next_available_name
      p[:secret] ||= get_random_secret
    end


    def get_next_available_name
      names = all_agent_names
      (100..999).find { |n| !names.include?(n) }
    end


    def all_agent_names
      User.all.pluck(:name).compact.map(&:to_i)
    end


    def get_random_secret
      (0..5).each_with_object('') { |n, pass| pass << rand(9).to_s }
    end
  end

  private


  def send_ahn_notification
    unless (self.changes.keys & %w{name secret}).empty?
      VoiceThread.run {
        sleep 0.05
        notify_ahn_about_update
      }
    end
  end


  def notify_ahn_about_update(key=nil)
    return if Rails.env.test?

    hash = {user_id: self.id}
    hash.merge!({key => send("#{key}_summary")}) if key

    AmqpManager.ahn_publish(hash)
  end
end

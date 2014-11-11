class User < ActiveRecord::Base

  # The "type" field is being used by asterisk for friend/peer:
  self.inheritance_column = :_type_disabled

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  rolify

  include UserNetworking
  include UpdateFields
  include UserFields
  include Keynames

  before_save   :send_ahn_notification
  after_create  :notify_ahn_about_update
  after_destroy :notify_ahn_about_update


  validates :name,       numericality: {only_integer: true},
                         allow_blank: true, uniqueness: true,
                         length: {is: 3}

  validates :secret,     numericality: {only_integer: true},
                         allow_blank: true

  validates :email,      presence: true, uniqueness: true,
                         email: true

  validates :locale,     inclusion: {in: WimConfig.ui_locales}

  validates :crmuser_id, numericality: {only_integer: true},
                         allow_blank: true, length: {is: 9}


  def set_admin_prefs(c = WimConfig)
    tap { |u|
      u.name      = c.admin_name
      u.email     = c.admin_email
      u.secret    = c.admin_secret
      u.password  = c.admin_password
      u.full_name = c.admin_fullname
      u.password_confirmation = c.admin_password
    }.save
  end


  def receives_all_events?
    Rails.cache.fetch("receives_all_events_#{self.id}", expires_in: 1.minute) {
      self.has_role?(:admin)
    }
  end


  def matches_requirements?(lang, skill)
    return false if lang.blank? || skill.blank?
    languages.include?(lang) && skills.include?(skill)
  end


  class << self

    # Caution, this is used by the external chef provisioning:
    #
    def seed_admin_user
      u = User.where(email: WimConfig.admin_email).first_or_initialize
      return if u.has_role?(:admin)

      u.add_role(:admin)
      u.set_admin_prefs
    end


    def build_param_hash(p, loc=WimConfig.ui_locales)
      { name:       p.fetch(:name, nil).try(:strip),
        email:      p.fetch(:email).strip.downcase,
        secret:     p.fetch(:secret, nil).try(:strip),
        locale:     p.fetch(:locale, loc.first),
        password:   p.fetch(:password),
        full_name:  p.fetch(:full_name).strip,
        crmuser_id: p.fetch(:crmuser_id, nil).try(:strip),
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
      [:name, :secret, :crmuser_id, :locale].each { |sym|
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
      all.pluck(:name).compact.map(&:to_i)
    end


    def get_random_secret
      (0..5).each_with_object('') { |n, pass| pass << rand(9).to_s }
    end
  end
end

module Keynames
  extend ActiveSupport::Concern

  def availability_keyname
    "#{Rails.env}.availability.#{self.id}"
  end

  def availability_default
    'unknown'
  end

  def activity_keyname
    "#{Rails.env}.activity.#{self.id}"
  end

  def activity_default
    'silent'
  end

  def token_keyname
    "#{Rails.env}.token.#{self.id}"
  end

  def dataset_keyname
    "#{Rails.env}.numbers-dataset"
  end


  module ClassMethods

    def online_users_keyname
      "#{Rails.env}.online-users"
    end

    def call_keyname(id)
      "#{Rails.env}.call.#{id}"
    end

    def call_pattern
      "#{Rails.env}.call.*"
    end

    def visibility_pattern
      "#{Rails.env}.visibility.*"
    end
  end
end

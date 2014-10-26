class UserSerializer < ActiveModel::Serializer

  attributes :id, :email, :full_name, :roles, :skills, :languages, :locale,
             :availability, :activity, :visibility, :name, :crmuser_id


  def roles
    object.role_summary
  rescue => e
    # FIXME With jruby, we see these now and then:
    #       undefined method `reverse' for nil:NilClass
    #
    Rails.logger.error e.message
    ['agent']
  end
end

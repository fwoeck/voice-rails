class UserSerializer < ActiveModel::Serializer

  attributes :id, :email, :full_name, :roles, :skills, :languages,
             :availability, :activity, :visibility, :name, :zendesk_id


  def roles
    object.role_summary
  end

  def skills
    object.skill_summary
  end

  def languages
    object.language_summary
  end
end

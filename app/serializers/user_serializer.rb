class UserSerializer < ActiveModel::Serializer

  attributes :id, :email, :full_name, :roles, :skills, :languages,
             :availability, :activity, :visibility, :name, :zendesk_id


  def roles
    object.role_summary.join(',')
  end

  def skills
    object.skill_summary.join(',')
  end

  def languages
    object.language_summary.join(',')
  end
end

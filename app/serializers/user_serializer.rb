class UserSerializer < ActiveModel::Serializer

  attributes :id, :email, :fullname, :roles, :skills,
             :languages, :availability, :agent_state

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

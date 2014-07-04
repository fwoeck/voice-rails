class User < ActiveRecord::Base
  self.inheritance_column = :_type_disabled

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  attr_reader :availability

  has_many :roles
  has_many :skills
  has_many :languages


  def role_summary
    roles.join(',')
  end

  def skill_summary
    skills.join(',')
  end

  def language_summary
    languages.join(',')
  end
end

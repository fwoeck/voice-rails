module ApplicationHelper

  def user_locale
    current_user ? current_user.locale || 'en' : 'en'
  end
end

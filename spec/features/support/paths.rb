module NavigationHelpers

  def home
    '/'
  end

  def login_page
    '/auth/login'
  end
end

RSpec.configuration.include NavigationHelpers, type: :feature

require 'timeout'

module BrowserHelpers

  def sign_in_with(email, pass='P4ssw0rd')
    visit login_page
    fill_in 'user_email',    with: email
    fill_in 'user_password', with: pass
    within('#new_user') { click_button 'Log in' }
  end


  def sign_out
    within('#logout_link') do
      click_link('a')
    end
  end


  def use_browser(name)
    Capybara.session_name = name
    set_browser_size(1200, 900)
  end


  def screenshot(name=nil)
    unless name
      $screenshot_count ||= -1
      $screenshot_count  +=  1
      name = '%02d' % $screenshot_count
    end

    path = "#{Rails.root}/tmp/screenshots/#{name}.png"
    page.save_screenshot(path, full: true)
  end
end

RSpec.configuration.include BrowserHelpers, type: :feature

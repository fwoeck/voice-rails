module CommonHelper

  extend self


  def clear_redis_keys
    keys = RPool.with { |con| con.keys("#{Rails.env}.*") }
    RPool.with { |con| con.del(*keys) } unless keys.empty?
  end


  def pry_on(_binding)
    if $activate_pry
      require 'pry'
      _binding.pry
    end
  end


  def configure_poltergeist_driver
    require 'capybara/poltergeist'

    pjslog = File.open('./log/phantomjs.log', 'a')
    pjslog.sync = true

    Capybara.register_driver :poltergeist do |app|
      Capybara::Poltergeist::Driver.new(
        app, {
          window_size:      [1600, 1200],
          phantomjs_logger:  pjslog,
          inspector:         false,
          debug:             false
        }
      )
    end

    Capybara.default_driver    = :poltergeist
    Capybara.javascript_driver = :poltergeist
  end


  def configure_selenium_driver
    require 'selenium/webdriver'

    Capybara.register_driver :selenium do |app|
      Selenium::WebDriver::Firefox::Binary.path='/usr/bin/firefox'

      profile = Selenium::WebDriver::Firefox::Profile.new
      profile['intl.accept_languages'] = 'en-us, en'
      # profile.enable_firebug

      Capybara::Selenium::Driver.new(app, profile: profile)
    end

    Capybara.default_driver    = :selenium
    Capybara.javascript_driver = :selenium
  end
end

require 'features/spec_helper'

feature 'Basic UI functions', js: true do

  let(:user) { create(:user) }

  scenario 'Basic login session' do
    sign_in_with(user.email)

    within('#logout_link') do
      expect(page).to have_content user.email
    end
  end
end

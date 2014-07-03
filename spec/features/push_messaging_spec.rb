require 'features/spec_helper'

feature 'Checking some basic push notifications', js: true do

  let(:user1) { create(:user, email: '100@mail.com', name: '100') }
  let(:user2) { create(:user, email: '101@mail.com', name: '101') }
  let(:user3) { create(:user, email: '102@mail.com', name: '102') }

  scenario 'Login with multiple browser sessions' do
    [user1, user2, user3]. each do |user|
      use_browser(user)
      sign_in_with(user.email)

      within('#logout_link') do
        expect(page).to have_content user.email
      end

      PushApi.send_message_to(user.id, {payload: "Hello #{user.email}!"})
    end

    [user1, user2, user3]. each do |user|
      use_browser(user)
      expect(page.evaluate_script 'pushMessages.length').to eql(1)
      expect(page.evaluate_script 'pushMessages[0].payload').to eql("Hello #{user.email}!")
    end
  end
end

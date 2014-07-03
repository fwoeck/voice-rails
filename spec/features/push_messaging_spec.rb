require 'features/spec_helper'

feature 'Checking some basic push notifications', js: true do

  let(:user1) { create(:user) }
  let(:user2) { create(:user, email: '101@mail.com', name: '101') }

  scenario 'Login with two browser sessions' do
    use_browser(:left)
    sign_in_with(user1.email)
    within('#logout_link') do
      expect(page).to have_content user1.email
    end

    use_browser(:right)
    sign_in_with(user2.email)
    within('#logout_link') do
      expect(page).to have_content user2.email
    end

    PushApi.send_message_to(user1, {payload: 'Hello 100!'})
    PushApi.send_message_to(user2, {payload: 'Hello 101!'})

    # Not yet implemented:

    # use_browser(:left)
    # expect(page.execute_script 'env.pushMessages.length').to eql(1)
    # expect(page.execute_script 'env.pushMessages[0].payload').to eql('Hello 100!')

    # use_browser(:right)
    # expect(page.execute_script 'env.pushMessages.length').to eql(1)
    # expect(page.execute_script 'env.pushMessages[0].payload').to eql('Hello 101!')
  end
end

require 'features/spec_helper'

feature 'Checking some basic push notifications', js: true do

  let!(:user1) { create(:user, email: '100@mail.com', name: '100') }
  let!(:user2) { create(:user, email: '101@mail.com', name: '101') }
  let!(:user3) { create(:user, email: '102@mail.com', name: '102') }


  scenario 'Sending out messages to authenticated clients only' do
    [user1, user2, user3].each do |user|
      use_browser(user)
      sign_in_with(user.email)

      within('#logout_link') do
        expect(page).to have_content user.email
      end

      AmqpManager.push_publish(user_ids: [user.id], data: {payload: "Hello #{user.email}!"})
    end
    sleep 0.25

    [user1, user2, user3]. each do |user|
      use_browser(user)
      expect(page.evaluate_script 'env.messages.length').to eql(1)
      expect(page.evaluate_script 'env.messages[0].payload').to eql("Hello #{user.email}!")
    end
  end


  scenario 'Sending out messages only to the last client of that user' do
    [:left, :right].each do |side|
      use_browser(side)
      sign_in_with(user1.email)

      within('#logout_link') do
        expect(page).to have_content user1.email
      end
    end

    AmqpManager.push_publish(user_ids: [user1.id], data: {payload: "Hello #{user1.email}!"})
    sleep 0.25

    use_browser(:left)
    expect(page.evaluate_script 'env.messages.length').to eql(0)

    use_browser(:right)
    expect(page.evaluate_script 'env.messages.length').to eql(1)
    expect(page.evaluate_script 'env.messages[0].payload').to eql("Hello #{user1.email}!")
  end


  scenario 'Stop sending messages after the client logged out' do
    sign_in_with(user1.email)
    within('#logout_link') do
      expect(page).to have_content user1.email
    end

    sign_out
    expect(page).not_to have_css '#logout_link'

    AmqpManager.push_publish(user_ids: [user1.id], data: {payload: "Hello #{user1.email}!"})
    sleep 0.25

    expect(page.evaluate_script 'env.messages.length').to eql(0)
  end


  scenario 'Sending multiple messages to one client' do
    sign_in_with(user1.email)

    within('#logout_link') do
      expect(page).to have_content user1.email
    end

    AmqpManager.push_publish(user_ids: [user1.id], data: {payload: '1'})
    AmqpManager.push_publish(user_ids: [user1.id], data: {payload: '2'})
    AmqpManager.push_publish(user_ids: [user1.id], data: {payload: '3'})
    sleep 0.25

    expect(page.evaluate_script 'env.messages.length').to eql(3)
    expect(page.evaluate_script 'env.messages[0].payload').to eql('1')
    expect(page.evaluate_script 'env.messages[1].payload').to eql('2')
    expect(page.evaluate_script 'env.messages[2].payload').to eql('3')
  end


  scenario 'Sending messages with invalid login/token' do
    visit '/'
    page.execute_script "env.userId='#{user1.id}'"
    page.execute_script 'env.sessionToken="1nval1d"'
    page.execute_script 'app.setupSSE()'

    AmqpManager.push_publish(user_ids: [user1.id], data: {payload: '1'})
    sleep 0.25

    expect(page.evaluate_script 'env.messages.length').to eql(0)
  end
end

require 'rails_helper'

RSpec.describe PushApi, type: :model do

  let(:user) { create(:user) }

  it 'responds to send_message_to' do
    expect { described_class.send_message_to(user, {}) }.not_to raise_error
  end
end

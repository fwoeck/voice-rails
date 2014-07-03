require 'rails_helper'

RSpec.describe User, type: :model do

  it 'creates an instance of its class' do
    expect(User.new).to be_a User
  end
end

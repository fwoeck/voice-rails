require 'rails_helper'

RSpec.describe User, type: :model do

  it "cereate an instance of its klass" do
    expect(User.new).to be_a User
  end
end

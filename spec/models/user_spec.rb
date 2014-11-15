require 'rails_helper'

RSpec.describe User, type: :model do

  let(:user) { create(:user) }


  context 'setting user attributes' do

    it 'allows to set a user language' do
      user.set_language('it')
      expect(user.reload.languages).to eq ['it']
    end
  end
end

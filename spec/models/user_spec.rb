require 'rails_helper'

RSpec.describe User, type: :model do

  let(:user) { create(:user) }

  it 'allows to set a user language' do
    user.set_language('it')
    expect(user.reload.languages.map(&:name)).to eq ['it']
  end

  it 'ignores setting a user language twice' do
    user.set_language('it')
    user.set_language('it')
    expect(user.reload.languages.map(&:name)).to eq ['it']
  end

  it 'allows to set multiple languages' do
    user.set_language('it')
    user.set_language('es')
    expect(user.reload.languages.map(&:name)).to eq ['it', 'es']
  end

  it 'allows to remove a language' do
    user.set_language('it')
    user.set_language('es')
    user.unset_language('it')
    expect(user.reload.languages.map(&:name)).to eq ['es']
  end

  it 'ignores unsetting an unset language' do
    user.unset_language('it')
    expect(user.reload.languages.map(&:name)).to eq []
  end

  it 'checks the language argument validity on set' do
    expect { user.set_language('none') }. to raise_error
  end

  it 'checks the language argument validity on unset' do
    expect { user.unset_language('none') }. to raise_error
  end
end

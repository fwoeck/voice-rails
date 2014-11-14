FactoryGirl.define do

  factory :user do
    email                 '100@mail.com'  # => devise login
    password              'P4ssw0rd'      # => devise password
    password_confirmation 'P4ssw0rd'
    name                  '100'           # => asterisk extension
    secret                '0000'          # => sip secret
    locale                'en'            # => UI locale
  end
end

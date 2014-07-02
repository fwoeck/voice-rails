FactoryGirl.define do

  factory :user do
    email                 '100@mail.com'  # => the devise login
    password              'P4ssw0rd'      # => the devise password
    password_confirmation 'P4ssw0rd'
    name                  '100'           # => the asterisk extension
    secret                '0000'          # => the sip secret
  end
end

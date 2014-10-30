module CustomerFakes
  extend ActiveSupport::Concern

  module ClassMethods

    def create_fake
    # raise unless Rails.env.development?
      fn = Faker::Name.name

      rpc_create(
        full_name:  fn,
        caller_ids: fake_caller_ids,
        email:      fake_email_for(fn)
      )
    end


    def fake_email_for(fn)
      Faker::Internet.email.sub(
        /^[^@]+/, fn.downcase.gsub(' ', '-').gsub(/[.']/, '')
      )
    end


    def fake_caller_ids
      [fake_caller_id, fake_caller_id].sample(1 + rand(2)).to_a
    end


    def fake_caller_id
      "0#{Faker::Number.number(8 + rand(4))}"
    end
  end
end

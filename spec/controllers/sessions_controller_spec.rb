require 'rails_helper'

describe SessionsController, type: :controller do

  describe "POST create" do
    before do
      @request.env["devise.mapping"] = Devise.mappings[:user]
    end

    let!(:user) { FactoryGirl.create(:user) }

    it "binds form authenticity token to current user's id" do
      post :create, user: { email: user.email, password: user.password }

      token = controller.user_session_token

      # FIXME This is a controller spec, but we are embedding knowledge
      #       about the DB-internals here. Can we wrap this in a service-
      #       class like this?
      #
      #       class ChecksUserTokens
      #         def initialize(user); ...; end
      #         def store_session_token; @redis.set...; end
      #         def fetch_session_token; @redis.get...; end
      #         def current_token_valid?; ...; end
      #       end
      #
      expect($redis.get("test.token.#{user.id}")).to eq(token)
    end

    it "it expires authenticity token after loggin out" do
      post :create, user: { email: user.email, password: user.password }
      token_1 = controller.user_session_token

      delete :destroy
      expect(controller.current_user).to be_nil

      post :create, user: { email: user.email, password: user.password }
      expect(response).to be_success
      token_2 = controller.user_session_token

      expect(token_1).not_to eq(token_2)

      pending "The second call doesn't hit the create action"

      # FIXME See comment above
      #
      expect($redis.get("test.token.#{user.id}")).to eq(token_2)
    end
  end
end

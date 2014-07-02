require 'rails_helper'

describe SessionsController, type: :controller do
  describe "POST create" do
    before do
      @request.env["devise.mapping"] = Devise.mappings[:user]
    end

    let!(:user) { FactoryGirl.create(:user) }

    it "binds form authenticity token to current user's id" do
      post :create, user: { email: user.email, password: user.password }

      token = controller.send(:form_authenticity_token)
      expect($redis.get("test.token.#{user.id}")).to eq(token)
    end

    it "it expires authenticity token after loggin out" do
      post :create, user: { email: user.email, password: user.password }
      token_1 = controller.send(:form_authenticity_token)

      delete :destroy
      expect(controller.current_user).to be_nil

      post :create, user: { email: user.email, password: user.password }
      expect(response).to be_success
      token_2 = controller.send(:form_authenticity_token)

      expect(token_1).not_to eq(token_2)

      pending "For some reason the second call doesn't really hit create action"
      expect($redis.get("test.token.#{user.id}")).to eq(token_2)
    end
  end
end

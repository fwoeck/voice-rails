require 'rails_helper'

describe SessionsController, type: :controller do
  describe "POST create" do
    let!(:user) { User.create(email: 'user@example.com', password: 'passphrase') }

    it "binds form authenticity token to current user's id" do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      allow(controller).to receive(:form_authenticity_token) { "form_authenticity_token" }

      post :create, user: { email: user.email, password: user.password }
      expect($redis.get("test.token.form_authenticity_token")).to eq(user.id.to_s)
    end
  end
end

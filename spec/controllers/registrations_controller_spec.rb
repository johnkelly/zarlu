require 'spec_helper'

describe RegistrationsController do
  before { @request.env["devise.mapping"] = Devise.mappings[:user] }

  describe "#create" do
    it "creates a subscriber for the user" do
      -> { post :create, user: { email: "test@example.com", password: "password", password_confirmation: "password" }}.should change(Subscriber, :count).by(1)
    end
  end
end

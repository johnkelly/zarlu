require 'spec_helper'

describe RegistrationsController do
  before { @request.env["devise.mapping"] = Devise.mappings[:user] }

  describe "#new" do
    context "plan selected" do
      before { get :new, plan: "first_class" }
      it { should assign_to(:plan).with("first_class") }
    end
    context "NO plan selected" do
      before { get :new }
      it { should assign_to(:plan).with("coach") }
    end
  end

  describe "#create" do
    it "creates a subscriber for the user" do
      -> { post :create, plan: "coach", user: { email: "test@example.com", password: "password", password_confirmation: "password" }}.should change(Subscriber, :count).by(1)
    end
  end
end
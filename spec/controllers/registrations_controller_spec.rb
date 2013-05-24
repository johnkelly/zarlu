require 'spec_helper'

describe RegistrationsController do
  let(:manager) { users(:manager_example_com) }
  let(:user) { users(:test_example_com) }

  before { @request.env["devise.mapping"] = Devise.mappings[:user] }

  describe "#create" do
    it "creates a subscriber for the user" do
      -> { post :create, user: { email: "test@example.com", password: "password", password_confirmation: "password" }}.should change(Subscriber, :count).by(1)
    end
  end

  describe "#update" do
    context "manager" do
      before do
        sign_in(manager)
        put :update, user: { name: "John", current_password: "password" }
      end
      it { should redirect_to welcome_path }
    end

    context "employee" do
      before do
        sign_in(user)
        put :update, user: { name: "John", current_password: "password" }
      end
      it { should redirect_to employee_welcome_path }
    end
  end
end

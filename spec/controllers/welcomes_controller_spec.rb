require 'spec_helper'

describe WelcomesController do
  let(:user) { users(:test_example_com) }
  before { sign_in user }

  describe "#create" do
    context "params support" do
      it "set the user's open support tool to true" do
        user.open_support_tool?.should be_false
        post :create, support: "true"
        response.should be_success
        user.reload.open_support_tool?.should be_true
      end
    end

    context "no params" do
      it "set the user's complete welcome tour property to true" do
        user.completed_welcome_tour?.should be_false
        post :create
        response.should be_success
        user.reload.completed_welcome_tour?.should be_true
      end
    end
  end

  describe "#show" do
    before { get :show }
    it { should respond_with(:success) }
  end
end

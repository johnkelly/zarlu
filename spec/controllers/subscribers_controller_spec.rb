require 'spec_helper'

describe SubscribersController do
  let(:subscriber) { subscribers(:subscribers_001) }
  let(:user) { users(:test_example_com) }

  before { sign_in(user) }

  describe "#show" do
    before { get :show }
    it { should respond_with(:success) }
    it { should assign_to(:subscriber).with(subscriber) }
    it { should assign_to(:users).with(subscriber.users) }
    it { should assign_to(:user).with(be_new_record) }
  end

  describe "#add_user" do
    context "success" do
      before { post :add_user, user: { email: "new@example.com" , password: "password" }}
      it { should redirect_to subscribers_url }
      it { should set_the_flash[:notice] }
      it { should assign_to(:subscriber).with(subscriber) }
      it { should assign_to(:user) }
    end

    context "error" do
      before { post :add_user, user: { email: "", password: "" }}
      it { should render_template(:show) }
      it { should set_the_flash[:alert].now }
      it { should assign_to(:subscriber).with(subscriber) }
      it { should assign_to(:user) }
    end
  end
end

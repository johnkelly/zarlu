require 'spec_helper'

describe SubscribersController do
  let(:subscriber) { subscribers(:subscribers_001) }
  let(:user) { users(:test_example_com) }
  let(:manager) { users(:manager_example_com) }

  before { sign_in(manager) }

  describe "#show" do
    before { get :show }
    it { should respond_with(:success) }
    it { should assign_to(:subscriber).with(subscriber) }
    it { should assign_to(:users).with(subscriber.users) }
    it { should assign_to(:user).with(be_new_record) }
    it { should assign_to(:managers).with([manager]) }
    it { should assign_to(:no_manager_users).with([manager]) }
  end

  describe "#add_user" do
    context "success" do
      before do
        ApplicationController.any_instance.should_receive(:track_activity!)
        SubscribersController.any_instance.should_receive(:charge_credit_card).with(subscriber)
        User.any_instance.stub(:valid_number_of_users).and_return(true)
        post :add_user, user: { email: "new@example.com" , password: "password" }
      end
      it { should redirect_to subscribers_url }
      it { should set_the_flash[:notice] }
      it { should assign_to(:subscriber).with(subscriber) }
      it { should assign_to(:user) }
    end

    context "error" do
      before { post :add_user, user: { email: "", password: "" }}
      it { should redirect_to subscribers_url }
      it { should set_the_flash[:alert] }
      it { should assign_to(:subscriber).with(subscriber) }
      it { should assign_to(:user) }
    end
  end

  describe "#promote_to_manager" do
    before do
      ApplicationController.any_instance.should_receive(:track_activity!)
      User.any_instance.should_receive(:promote_to_manager!).and_return(true)
      put :promote_to_manager, user_id: user.to_param
    end
    it { should assign_to(:subscriber).with(subscriber) }
    it { should assign_to(:users).with(subscriber.users) }
    it { should assign_to(:user).with(user) }
    it { should redirect_to subscribers_url }
    it { should set_the_flash[:notice] }
  end

  describe "#change_manager" do
    before do
      user.manager_id = nil
      user.save!
    end
    context "manager id is valid" do
      before { put :change_manager, user_id: user.to_param, manager_id: manager.to_param }
      it { should respond_with(:success) }
      it { should assign_to(:subscriber).with(subscriber) }
      it { should assign_to(:users).with(subscriber.users) }
      it { should assign_to(:user).with(user) }
      it { should assign_to(:manager).with(manager) }
      it "sets the user's manager_id" do
        user.reload.manager_id.should == manager.id
      end
    end

    context "manager id is nil" do
      before { put :change_manager, user_id: user.to_param, manager_id: "nil" }
      it { should respond_with(:success) }
      it { should assign_to(:subscriber).with(subscriber) }
      it { should assign_to(:users).with(subscriber.users) }
      it { should assign_to(:user).with(user) }
      it "sets the user's manager_id" do
        user.reload.manager_id.should == nil
      end
    end
  end
end

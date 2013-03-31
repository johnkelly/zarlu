require 'spec_helper'

describe SubscribersController do
  let(:subscriber) { subscribers(:subscribers_001) }
  let(:user) { users(:test_example_com) }
  let(:manager) { users(:manager_example_com) }

  before { sign_in(manager) }

  describe "#show" do
    before { get :show }
    it { should respond_with(:success) }
    it { assigns(:subscriber).should == subscriber }
    it { assigns(:users).should == subscriber.users }
    it { assigns(:employees).should == subscriber.users.sort_by(&:display_name) }
    it { assigns(:user).should be_present }
    it { assigns(:managers).should == [manager] }
    it { assigns(:events) }
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
      it { assigns(:subscriber).should == subscriber }
      it { assigns(:user) }
    end

    context "error" do
      before { post :add_user, user: { email: "", password: "" }}
      it { should redirect_to subscribers_url }
      it { should set_the_flash[:alert] }
      it { assigns(:subscriber).should == subscriber }
      it { assigns(:user) }
    end
  end

  describe "#promote_to_manager" do
    before do
      ApplicationController.any_instance.should_receive(:track_activity!)
      User.any_instance.should_receive(:promote_to_manager!).and_return(true)
      put :promote_to_manager, user_id: user.to_param
    end
    it { assigns(:subscriber).should == subscriber }
    it { assigns(:users).should == subscriber.users }
    it { assigns(:user).should == user }
    it { should redirect_to subscribers_url }
    it { should set_the_flash[:notice] }
  end

  describe "#demote_to_employee" do
    context "1 manager" do
      before do
        Subscriber.any_instance.should_receive(:managers).and_return([1])
        User.any_instance.should_not_receive(:demote_to_employee!)
        put :demote_to_employee, user_id: user.to_param
      end
      it { assigns(:subscriber).should == subscriber }
      it { assigns(:users).should == subscriber.users }
      it { assigns(:user).should == user }
      it { should redirect_to subscribers_url }
      it { should set_the_flash[:alert] }
    end

    context "more than 1 manager" do
      before do
        Subscriber.any_instance.should_receive(:managers).and_return([1,2])
        User.any_instance.should_receive(:demote_to_employee!)
        put :demote_to_employee, user_id: user.to_param
      end
      it { assigns(:subscriber).should == subscriber }
      it { assigns(:users).should == subscriber.users }
      it { assigns(:user).should == user }
      it { should set_the_flash[:notice] }
    end
  end

  describe "#change_manager" do
    before do
      User.any_instance.should_receive(:change_manager!).with(manager.id)
      put :change_manager, user_id: user.to_param, user: { manager_id: manager.to_param }
    end
    it { assigns(:subscriber).should == subscriber }
    it { assigns(:users).should == subscriber.users }
    it { assigns(:user).should == user }
    it { should respond_with(204) }
  end
end

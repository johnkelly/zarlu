require 'spec_helper'

describe SubscribersController do
  let(:subscriber) { subscribers(:trial) }
  let(:user) { users(:test_example_com) }
  let(:manager) { users(:manager_example_com) }

  before { sign_in(manager) }

  describe "#show" do
    context "no time off view" do
      before { get :show, time_off_view: "time_off_used" }
      it { should respond_with(:success) }
      it { assigns(:subscriber).should == subscriber }
      it { assigns(:users).should == subscriber.users }
      it { assigns(:user).should be_present }
      it { assigns(:managers).should == [manager] }
      it { assigns(:events) }
      it { assigns(:time_off_view).should == "time_off_used" }
    end

    context "time_off_view param" do
      before { get :show, time_off_view: "time_off_accrued" }
      it { should respond_with(:success) }
      it { assigns(:subscriber).should == subscriber }
      it { assigns(:users).should == subscriber.users }
      it { assigns(:user).should be_present }
      it { assigns(:managers).should == [manager] }
      it { assigns(:events) }
      it { assigns(:time_off_view).should == "time_off_accrued" }
    end
  end

  describe "#update" do
    context "http" do
      before { patch :update, id: subscriber.to_param, subscriber: { name: "Zarlu" }}
      it { should respond_with(204) }
    end

    context "database" do
      before { patch :update, id: subscriber.to_param, subscriber: { name: "Zarlu" }}
      subject { subscriber.reload }
      its(:name) { should == "Zarlu" }
    end
  end

  describe "#promote_to_manager" do
    before do
      ApplicationController.any_instance.should_receive(:track_activity!)
      User.any_instance.should_receive(:promote_to_manager!).and_return(true)
      patch :promote_to_manager, user_id: user.to_param
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
        patch :demote_to_employee, user_id: user.to_param
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
        patch :demote_to_employee, user_id: user.to_param
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
      patch :change_manager, user_id: user.to_param, user: { manager_id: manager.to_param }
    end
    it { assigns(:subscriber).should == subscriber }
    it { assigns(:users).should == subscriber.users }
    it { assigns(:user).should == user }
    it { should respond_with(204) }
  end
end

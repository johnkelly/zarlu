require 'spec_helper'

describe Subscriber::UsersController do
  let(:manager) { users(:manager_example_com) }
  let(:user) { users(:test_example_com) }
  let(:subscriber) { subscribers(:trial) }
  before { sign_in(manager) }

  describe "#create" do
    context "success" do
      before do
        ApplicationController.any_instance.should_receive(:track_activity!)
        InviteEmailWorker.should_receive(:perform_async)
        Subscriber::UsersController.any_instance.should_receive(:charge_credit_card).with(subscriber)
        post :create, user: { email: "new@example.com" , password: "password" }
      end
      it { should redirect_to subscribers_url }
      it { should set_the_flash[:notice] }
      it { assigns(:subscriber).should == subscriber }
      it { assigns(:user) }
    end

    context "error" do
      before { post :create, user: { email: "", password: "" }}
      it { should redirect_to subscribers_url }
      it { should set_the_flash[:alert] }
      it { assigns(:subscriber).should == subscriber }
      it { assigns(:user) }
    end
  end

  describe "#update" do
    context "http" do
      before { put :update, id: user.to_param, user: { join_date: "2011-04-04" }, format: :json }
      it { should respond_with(204) }
      it { assigns(:user).should == user }
    end

    context "update database" do
      context "european date" do
        before { put :update, id: user.to_param, user: { join_date: "2011-04-04" }, format: :json }
        subject { user.reload }
        its(:join_date) { should == Date.new(2011, 04, 04) }
      end

      context "american date" do
        before { put :update, id: user.to_param, user: { join_date: "04/04/2011" }, format: :json }
        subject { user.reload }
        its(:join_date) { should == Date.new(2011, 04, 04) }
      end
    end
  end

  describe "#destroy" do
    context "http" do
      context "can destroy" do
        before { User.any_instance.should_receive(:stop_charging_subscriber) }
        before { delete :destroy, id: user.to_param }
        it { should redirect_to subscribers_url }
        it { should set_the_flash[:notice] }
        it { assigns(:user).should == user }
      end

      context "can't destroy" do
        before { delete :destroy, id: manager.to_param }
        it { should redirect_to subscribers_url }
        it { should set_the_flash[:alert] }
        it { assigns(:user).should == manager }
      end
    end

    context "update database" do
      before { User.any_instance.should_receive(:stop_charging_subscriber) }
      it "deletes the user" do
        expect { delete :destroy, id: user.to_param}.to change(User, :count).by(-1)
      end
    end
  end
end

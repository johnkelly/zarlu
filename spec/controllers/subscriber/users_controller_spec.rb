require 'spec_helper'

describe Subscriber::UsersController do
  let(:manager) { users(:manager_example_com) }
  let(:user) { users(:test_example_com) }
  before { sign_in(manager) }

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
    before { User.any_instance.should_receive(:stop_charging_subscriber) }

    context "http" do
      before { delete :destroy, id: user.to_param }
      it { should redirect_to subscribers_url }
      it { should set_the_flash[:notice] }
      it { assigns(:user).should == user }
    end

    context "update database" do
      it "deletes the user" do
        expect { delete :destroy, id: user.to_param}.to change(User, :count).by(-1)
      end
    end
  end
end

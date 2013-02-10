require 'spec_helper'

describe SubscriptionsController do
  let(:user) { users(:test_example_com) }
  let(:subscriber) { subscribers(:subscribers_001) }
  before { sign_in user }

  describe "#update" do
    before do
      subscriber.plan.should == "coach"
      put :update, subscriber: { plan: "first_class", card_token: "" }
    end
    it { should redirect_to subscriptions_url }
    it { should assign_to(:subscriber).with(subscriber) }
    it "should update the subscriber's plan" do
      subscriber.reload.plan.should == "first_class"
    end
  end

  describe "#show" do
    before { get :show }
    it { should respond_with(:success) }
    it { should assign_to(:subscriber).with(subscriber) }
  end
end

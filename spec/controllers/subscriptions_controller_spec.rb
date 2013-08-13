require 'spec_helper'

describe SubscriptionsController do
  let(:user) { users(:test_example_com) }
  let(:subscriber) { subscribers(:trial) }
  before { sign_in user }

  describe "#update" do
    context "success" do
      context "no coupon" do
        before do
          Subscriber.any_instance.should_receive(:save_credit_card).with(user, "").and_return(true)
          patch :update, subscriber: { card_token: "fake_token", coupon: "" }
        end
        it { should redirect_to subscriptions_url }
        it { assigns(:subscriber).should == subscriber }
      end

      context "coupon" do
        before do
          Subscriber.any_instance.should_receive(:save_credit_card).with(user, "ERLIBIRD").and_return(true)
          patch :update, subscriber: { card_token: "fake_token", coupon: "ERLIBIRD" }
        end
        it { should redirect_to subscriptions_url }
        it { assigns(:subscriber).should == subscriber }
      end
    end

    context "failure stripe error with create customer" do
      before do
        Subscriber.any_instance.should_receive(:save_credit_card).with(user, nil).and_return(false)
        patch :update, subscriber: { card_token: "fake_token" }
      end
      it { should render_template(:show) }
      it { should set_the_flash[:alert].now }
    end

    context "failure missing params" do
      before do
        Subscriber.any_instance.should_not_receive(:save_credit_card)
        patch :update, subscriber: { card_token: "" }
      end
      it { should render_template(:show) }
      it { should set_the_flash[:alert].now }
    end
  end

  describe "#show" do
    before { get :show }
    it { should respond_with(:success) }
    it { assigns(:subscriber).should == subscriber }
    it { assigns(:user_count).should == subscriber.users.count }
  end
end

require 'spec_helper'

describe SubscriptionsController do
  let(:user) { users(:test_example_com) }
  let(:subscriber) { subscribers(:subscribers_001) }
  before { sign_in user }

  describe "#update" do
    context "success" do
      context "first time sign in" do
        before do
          Subscriber.any_instance.should_receive(:save_customer).and_return(true)
          subscriber.plan.should == "coach"
          User.any_instance.should_receive(:sign_in_count).and_return(1)
          put :update, subscriber: { plan: "first_class", card_token: "fake_token" }
        end
        it { should redirect_to welcome_url }
        it { should set_the_flash[:analytics].to("/vp/add_first_class_plan") }
        it { should assign_to(:subscriber).with(subscriber) }
        it "should update the subscriber's plan" do
          subscriber.reload.plan.should == "first_class"
        end
      end

      context "future sign in" do
        before do
          Subscriber.any_instance.should_receive(:save_customer).and_return(true)
          subscriber.plan.should == "coach"
          User.any_instance.should_receive(:sign_in_count).and_return(10)
          put :update, subscriber: { plan: "first_class", card_token: "fake_token" }
        end
        it { should redirect_to subscriptions_url }
        it { should set_the_flash[:analytics].to("/vp/add_first_class_plan") }
        it { should assign_to(:subscriber).with(subscriber) }
        it "should update the subscriber's plan" do
          subscriber.reload.plan.should == "first_class"
        end
      end
    end

    context "failure stripe error with create customer" do
      before do
        Subscriber.any_instance.should_receive(:save_customer).and_return(false)
        subscriber.plan.should == "coach"
        put :update, subscriber: { plan: "first_class", card_token: "fake_token" }
      end
      it { should render_template(:show) }
      it { should set_the_flash[:alert].now }
      it "should not change the subscriber's plan" do
        subscriber.reload.plan.should == "coach"
      end
    end

    context "failure missing params" do
      before do
        Subscriber.any_instance.should_not_receive(:save_customer)
        subscriber.plan.should == "coach"
        put :update, subscriber: { plan: "", card_token: "" }
      end
      it { should render_template(:show) }
      it { should set_the_flash[:alert].now }
      it "should not change the subscriber's plan" do
        subscriber.reload.plan.should == "coach"
      end
    end
  end

  describe "#show" do
    before { get :show }
    it { should respond_with(:success) }
    it { should assign_to(:subscriber).with(subscriber) }
  end
end

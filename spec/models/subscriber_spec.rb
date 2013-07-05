require 'spec_helper'

describe Subscriber do
  let(:trial_user) { users(:manager_example_com) }
  let(:trial_subscriber) { subscribers(:trial) }
  let(:paid_subscriber) { subscribers(:paid) }

  describe "attributes" do
    it { should have_many(:users).dependent(:destroy) }
    it { should have_many(:company_settings).dependent(:destroy) }
    it { should have_many(:accruals).dependent(:destroy) }
    it { should have_many(:holidays).dependent(:destroy) }
  end

  describe "after_create" do
    it "creates a vacation company setting record" do
      -> { Subscriber.create! }.should change(VacationCompanySetting, :count).by(1)
      -> { Subscriber.create! }.should change(SickCompanySetting, :count).by(1)
      -> { Subscriber.create! }.should change(PersonalCompanySetting, :count).by(1)
      -> { Subscriber.create! }.should change(UnpaidCompanySetting, :count).by(1)
      -> { Subscriber.create! }.should change(OtherCompanySetting, :count).by(1)
    end
  end

  describe "self.expired_yesterday_with_credit_card" do
    it "returns an array of subscriber who have a credit card and their trial expired yesterday" do
      paid_subscriber.has_credit_card?.should be_true
      Subscriber.any_instance.stub(:expired_yesterday?).and_return(true)
      Subscriber.expired_yesterday_with_credit_card.should == [paid_subscriber]
    end
  end

  describe "save_credit_card" do
    context "valid" do
      context "customer token nil" do
        it "calls add_credit_card" do
          trial_subscriber.stub(:customer_token).and_return(nil)
          trial_subscriber.should_receive(:add_credit_card).and_return(true)
          trial_subscriber.save_credit_card(trial_user).should == true
        end
      end

      context "customer token present" do
        it "calls change_credit_card" do
          trial_subscriber.stub(:customer_token).and_return("fake_token")
          trial_subscriber.should_receive(:change_credit_card).and_return(true)
          trial_subscriber.save_credit_card(trial_user).should == true
        end
      end

      context "Stripe Error" do
        it "returns false" do
          error_message = double(message: "Stripe had an issue")
          trial_subscriber.stub(:customer_token).and_return("fake_token")
          trial_subscriber.should_receive(:change_credit_card).and_raise(Stripe::StripeError.new(error_message))
          trial_subscriber.save_credit_card(trial_user).should == false
        end
      end
    end

    context "invalid subscriber data" do
      it "returns false" do
        trial_subscriber.stub(:valid?).and_return(false)
        trial_subscriber.save_credit_card(trial_user).should == false
      end
    end
  end

  describe "has_credit_card?" do
    context "has customer token" do
      it "returns true" do
        trial_subscriber.stub(:customer_token).and_return("fake_token")
        trial_subscriber.has_credit_card?.should be_true
      end
    end
    context "has NO customer token" do
      it "returns false" do
        trial_subscriber.has_credit_card?.should be_false
      end
    end
  end

  describe "no managers assigned" do
    pending
  end

  describe "mangers" do
    pending
  end

  describe "update_subscription_users" do
    it "calls Stripe update subscription" do
      Subscriber.any_instance.stub(:users).and_return((1..14).to_a)
      stripe = double("Stripe")
      Stripe::Customer.should_receive(:retrieve).with(paid_subscriber.customer_token).and_return(stripe)
      stripe.should_receive(:update_subscription).with(plan: "public_paid_plan", quantity: 14)
      paid_subscriber.update_subscription_users
    end
  end

  describe "available_events" do
    it "returns an array of enabled event types" do
      paid_subscriber.available_events.should == TimeOffValue.kinds
    end
  end

  describe "trial?" do
    context "NOT expired" do
      it "returns true" do
        paid_subscriber.stub(:created_at).and_return(1.second.ago)
        paid_subscriber.trial?.should be_true
      end
    end

    context "expired" do
      it "returns false" do
        paid_subscriber.stub(:created_at).and_return(30.days.ago - 1.second)
        paid_subscriber.trial?.should be_false
      end
    end
  end

  describe "last_trial_day" do
    it "returns 30 days from the time the account was created" do
      trial_subscriber.last_trial_day.should == trial_subscriber.created_at + 30.days
    end
  end

  describe "expired_yeserday?" do
    subject { trial_subscriber }

    context "expired yesterday" do
      before { trial_subscriber.stub(:created_at).and_return(31.days.ago) }
      its(:expired_yesterday?) { should == true }
    end

    context "expires on a different day" do
      its(:expired_yesterday?) { should == false }
    end
  end
end

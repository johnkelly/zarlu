require 'spec_helper'

describe Subscriber do
  let(:unpaid_subscriber) { subscribers(:subscribers_001) }
  let(:paid_subscriber) { subscribers(:subscribers_002) }

  describe "attributes" do
    it { should have_many(:users) }
    it { should ensure_inclusion_of(:plan).in_array(['public_paid_plan']).allow_blank }
  end

  describe "after_create" do
    it "creates a vacation company setting record" do
      -> { Subscriber.create! }.should change(VacationCompanySetting, :count).by(1)
      -> { Subscriber.create! }.should change(SickCompanySetting, :count).by(1)
      -> { Subscriber.create! }.should change(HolidayCompanySetting, :count).by(1)
      -> { Subscriber.create! }.should change(PersonalCompanySetting, :count).by(1)
      -> { Subscriber.create! }.should change(UnpaidCompanySetting, :count).by(1)
      -> { Subscriber.create! }.should change(OtherCompanySetting, :count).by(1)
    end
  end

  describe "save_credit_card" do
    context "valid" do
      context "customer token nil" do
        it "calls add_credit_card" do
          unpaid_subscriber.stub(:customer_token).and_return(nil)
          unpaid_subscriber.should_receive(:add_credit_card).and_return(true)
          unpaid_subscriber.save_credit_card.should == true
        end
      end

      context "customer token present" do
        it "calls change_credit_card" do
          unpaid_subscriber.stub(:customer_token).and_return("fake_token")
          unpaid_subscriber.should_receive(:change_credit_card).and_return(true)
          unpaid_subscriber.save_credit_card.should == true
        end
      end

      context "Stripe Error" do
        it "returns false" do
          error_message = stub(message: "Stripe had an issue")
          unpaid_subscriber.stub(:customer_token).and_return("fake_token")
          unpaid_subscriber.should_receive(:change_credit_card).and_raise(Stripe::StripeError.new(error_message))
          unpaid_subscriber.save_credit_card.should == false
        end
      end
    end

    context "invalid subscriber data" do
      it "returns false" do
        unpaid_subscriber.stub(:valid?).and_return(false)
        unpaid_subscriber.save_credit_card.should == false
      end
    end
  end

  describe "under_user_limit_for_free_plan" do
    context "over free limit of 10 users" do
      it "returns false" do
        Subscriber.any_instance.stub(:users).and_return((1..11).to_a)
        unpaid_subscriber.under_user_limit_for_free_plan.should be_false
      end
    end

    context "at free limit of 10 user" do
      it "returns false" do
        Subscriber.any_instance.stub(:users).and_return((1..10).to_a)
        unpaid_subscriber.under_user_limit_for_free_plan.should be_false
      end
    end

    context "under free limit of 10 users" do
      it "returns true" do
        Subscriber.any_instance.stub(:users).and_return([1])
        unpaid_subscriber.under_user_limit_for_free_plan.should be_true
      end
    end
  end

  describe "has_credit_card?" do
    context "has customer token" do
      it "returns true" do
        unpaid_subscriber.stub(:customer_token).and_return("fake_token")
        unpaid_subscriber.has_credit_card?.should be_true
      end
    end
    context "has NO customer token" do
      it "returns false" do
        unpaid_subscriber.has_credit_card?.should be_false
      end
    end
  end

  describe "paid_plan?" do
    context "subscriber has a plan" do
      it "returns true" do
        paid_subscriber.paid_plan?.should be_true
      end
    end

    context "subscriber with no plan" do
      it "returns false" do
        unpaid_subscriber.paid_plan?.should be_false
      end
    end
  end

  describe "no managers assigned" do
    pending
  end

  describe "mangers" do
    pending
  end

  describe "add_or_update_subscription" do
    context "user count greater than 10" do
      it "calls Stripe update subscription" do
        Subscriber.any_instance.stub(:users).and_return((1..14).to_a)
        stripe = mock("Stripe")
        Stripe::Customer.should_receive(:retrieve).with(paid_subscriber.customer_token).and_return(stripe)
        stripe.should_receive(:update_subscription).with(plan: "public_paid_plan", quantity: 4)
        paid_subscriber.add_or_update_subscription
      end
    end

    context "user count less than 10" do
      it "does nothing" do
        paid_subscriber.under_user_limit_for_free_plan.should be_true
        Stripe::Customer.should_not_receive(:retrieve)
        paid_subscriber.add_or_update_subscription
      end
    end
  end

  describe "available_events" do
    it "returns an array of enabled event types" do
      paid_subscriber.available_events.should == Event.kinds
    end
  end
end

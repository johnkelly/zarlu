require 'spec_helper'

describe Subscriber do
  let(:coach_subscriber) { subscribers(:subscribers_001) }
  let(:business_subscriber) { subscribers(:subscribers_002) }
  let(:business_select_subscriber) { subscribers(:subscribers_003) }
  let(:first_class_subscriber) { subscribers(:subscribers_004) }

  describe "attributes" do
    it { should have_many(:users) }
    it { should validate_presence_of(:plan) }
    it { should ensure_inclusion_of(:plan).in_array(['coach', 'business', 'business_select', 'first_class']) }
  end

  describe "save_customer" do
    context "valid" do
      context "customer token nil" do
        it "calls create_customer" do
          coach_subscriber.stub(:customer_token).and_return(nil)
          coach_subscriber.should_receive(:create_customer).and_return(true)
          coach_subscriber.save_customer.should == true
        end
      end

      context "customer token present" do
        it "calls update_customer" do
          coach_subscriber.stub(:customer_token).and_return("fake_token")
          coach_subscriber.should_receive(:update_customer).and_return(true)
          coach_subscriber.save_customer.should == true
        end
      end

      context "Stripe Error" do
        it "returns false" do
          error_message = stub(message: "Stripe had an issue")
          coach_subscriber.stub(:customer_token).and_return("fake_token")
          coach_subscriber.should_receive(:update_customer).and_raise(Stripe::StripeError.new(error_message))
          coach_subscriber.save_customer.should == false
        end
      end
    end

    context "invalid subscriber data" do
      it "returns false" do
        coach_subscriber.stub(:valid?).and_return(false)
        coach_subscriber.save_customer.should == false
      end
    end
  end

  describe "plan_users" do
    it "returns 10 for coach plan" do
      coach_subscriber.plan_users.should == 10
    end

    it "returns 40 for business plan" do
      business_subscriber.plan_users.should == 40
    end

    it "returns 100 for business select plan" do
      business_select_subscriber.plan_users.should == 100
    end

    it "returns 175 for first class plan" do
      first_class_subscriber.plan_users.should == 175
    end
  end

  describe "plan_cost" do
    it "returns 0 for coach plan" do
      coach_subscriber.plan_cost.should == 0
    end

    it "returns 50 for business plan" do
      business_subscriber.plan_cost.should == 50
    end

    it "returns 100 for business select plan" do
      business_select_subscriber.plan_cost.should == 100
    end

    it "returns 150 for first class plan" do
      first_class_subscriber.plan_cost.should == 150
    end
  end

  describe "under_user_limit_for_plan" do
    context "over plan limit" do
      it "returns false" do
        Subscriber.any_instance.stub(:users).and_return((1..11).to_a)
        coach_subscriber.under_user_limit_for_plan.should be_false
      end
    end

    context "at plan limit" do
      it "returns false" do
        Subscriber.any_instance.stub(:users).and_return((1..10).to_a)
        coach_subscriber.under_user_limit_for_plan.should be_false
      end
    end

    context "under plan limit" do
      it "returns true" do
        Subscriber.any_instance.stub(:users).and_return([1])
        coach_subscriber.under_user_limit_for_plan.should be_true
      end
    end
  end

  describe "paid_plan?" do
    context "coach plan" do
      it "returns false" do
        coach_subscriber.paid_plan?.should be_false
      end
    end

    context "business plan" do
      it "returns true" do
        business_subscriber.paid_plan?.should be_true
      end
    end
  end
end

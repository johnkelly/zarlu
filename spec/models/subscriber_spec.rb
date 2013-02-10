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

  describe "plan_users" do
    it "returns 2 for coach plan" do
      coach_subscriber.plan_users.should == 2
    end

    it "returns 30 for business plan" do
      business_subscriber.plan_users.should == 30
    end

    it "returns 75 for business select plan" do
      business_select_subscriber.plan_users.should == 75
    end

    it "returns 150 for first class plan" do
      first_class_subscriber.plan_users.should == 150
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
        Subscriber.any_instance.stub(:users).and_return([1,2,3])
        coach_subscriber.under_user_limit_for_plan.should be_false
      end
    end

    context "at plan limit" do
      it "returns false" do
        Subscriber.any_instance.stub(:users).and_return([1,2])
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
end

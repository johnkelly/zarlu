require 'spec_helper'

describe HomesController do

  describe "#index" do
    it "returns success" do
      get :index
      response.should be_success
    end
  end

  describe "#show" do
    context "user on free plan" do
      context "no calendar type" do
        before do
          sign_in users(:test_example_com)
          get :show
        end
        it { should respond_with(:success) }
        it { assigns(:calendar_type).should == "user" }
        it { assigns(:available_events).should == [["Vacation", 0], ["Sick", 1], ["Holiday", 2], ["Personal", 3], ["Unpaid", 4], ["Other", 5]] }
      end

      context "calendar type param" do
        before do
          sign_in users(:test_example_com)
          get :show, calendar_type: "manager"
        end
        it { should respond_with(:success) }
        it { assigns(:calendar_type).should == "manager" }
        it { assigns(:available_events).should == [["Vacation", 0], ["Sick", 1], ["Holiday", 2], ["Personal", 3], ["Unpaid", 4], ["Other", 5]] }
      end
    end

    context "user on premium plan with no credit card" do
      before do
        sign_in users(:freeloader_example_com)
        get :show
      end
      it { should redirect_to(subscriptions_url) }
      it { should set_the_flash[:alert] }
    end
  end

  describe "#pricing" do
    it "returns success" do
      get :pricing
      response.should be_success
    end
  end

  describe "#privacy" do
    it "returns success" do
      get :privacy
      response.should be_success
    end
  end
end

require 'spec_helper'

describe HomesController do
  let(:subscriber) { subscribers(:subscribers_001) }

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
        it { assigns(:subscriber).should == subscriber }
        it { assigns(:calendar_type).should == "user" }
        it { assigns(:available_events).should == [["Vacation", 0], ["Sick", 1], ["Holiday", 2], ["Personal", 3], ["Unpaid", 4], ["Other", 5]] }
      end

      context "calendar type param" do
        before do
          sign_in users(:test_example_com)
          get :show, calendar_type: "manager"
        end
        it { should respond_with(:success) }
        it { assigns(:subscriber).should == subscriber }
        it { assigns(:calendar_type).should == "manager" }
        it { assigns(:available_events).should == [["Vacation", 0], ["Sick", 1], ["Holiday", 2], ["Personal", 3], ["Unpaid", 4], ["Other", 5]] }
      end
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

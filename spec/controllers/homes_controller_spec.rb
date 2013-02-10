require 'spec_helper'

describe HomesController do

  describe "#index" do
    it "returns success" do
      get 'index'
      response.should be_success
    end
  end

  describe "#show" do
    context "user on free plan" do
      before do
        sign_in users(:test_example_com)
        get :show
      end
      it { should respond_with(:success) }
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
      get 'pricing'
      response.should be_success
    end
  end

end

require 'spec_helper'

describe HomesController do

  describe "#index" do
    it "returns success" do
      get 'index'
      response.should be_success
    end
  end

  describe "#show" do
    before do
      sign_in users(:test_example_com)
      get :show
    end
    it { should respond_with(:success) }
  end

  describe "#pricing" do
    it "returns success" do
      get 'pricing'
      response.should be_success
    end
  end

end

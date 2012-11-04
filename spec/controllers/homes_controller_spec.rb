require 'spec_helper'

describe HomesController do

  describe "#index" do
    it "returns success" do
      get 'index'
      response.should be_success
    end
  end

  describe "#pricing" do
    it "returns success" do
      get 'pricing'
      response.should be_success
    end
  end

end

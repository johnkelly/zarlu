require 'spec_helper'

describe WelcomesController do
  describe "#show" do
    before do
      sign_in users(:test_example_com)
      get :show
    end

    it { should respond_with(:success) }
  end
end

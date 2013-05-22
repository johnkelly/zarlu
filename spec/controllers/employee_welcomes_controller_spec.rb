require 'spec_helper'

describe EmployeeWelcomesController do
  let(:user) { users(:test_example_com) }
  before { sign_in user }

  describe "#show" do
    before { get :show }
    it { should respond_with(:success) }
  end
end

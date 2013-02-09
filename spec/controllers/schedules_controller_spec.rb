require 'spec_helper'

describe SchedulesController do
  let(:user) { users(:test_example_com) }
  before { sign_in(user) }

  describe "#show" do
    before { get :show, id: user.to_param }
    it { should respond_with(:success) }
    it { should assign_to(:events) }
    it { should assign_to(:pending_events) }
    it { should assign_to(:rejected_events) }
  end
end

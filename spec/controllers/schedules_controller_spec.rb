require 'spec_helper'

describe SchedulesController do
  let(:user) { users(:test_example_com) }
  before { sign_in(user) }

  describe "#show" do
    before { get :show, id: user.to_param }
    it { should respond_with(:success) }
    it { assigns(:events) }
    it { assigns(:pending_events) }
    it { assigns(:rejected_events) }
  end
end

require 'spec_helper'

describe SubscribersController do
  let(:subscriber) { subscribers(:subscribers_001) }
  let(:user) { users(:test_example_com) }

  before { sign_in(user) }

  describe "#show" do
    before { get :show }
    it { should respond_with(:success) }
    it { should assign_to(:subscriber).with(subscriber) }
    it { should assign_to(:users).with(subscriber.users) }
    it { should assign_to(:user).with(be_a_new_record) }
  end
end

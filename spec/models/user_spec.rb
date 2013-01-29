require 'spec_helper'

describe User do
  let(:manager) { users(:manager_example_com) }
  let(:user) { users(:test_example_com) }

  describe "attributes" do
    it { should belong_to(:subscriber) }
    it { should have_many(:events).dependent(:destroy) }
    it { should validate_presence_of(:subscriber_id) }
  end

  describe "promote to manager!" do
    it "sets the user's manager attribute to true" do
      user.manager.should be_false
      user.promote_to_manager!
      user.reload.manager.should be_true
    end
  end

  describe "employees" do
    context "no employees" do
      subject { user }
      its(:employees) { should be_empty }
    end

    context "has employees" do
      subject { manager }
      its(:employees) { should == [user] }
    end
  end
end

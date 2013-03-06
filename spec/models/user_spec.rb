require 'spec_helper'

describe User do
  let(:manager) { users(:manager_example_com) }
  let(:user) { users(:test_example_com) }

  describe "attributes" do
    it { should belong_to(:subscriber) }
    it { should have_many(:events).dependent(:destroy) }
    it { should have_many(:activities).dependent(:destroy) }
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

  describe "has_manager?" do
    context "user with a manager id" do
      it "returns true" do
        user.manager_id.should be_present
        user.has_manager?.should be_true
      end
    end

    context "user without a manager id" do
      it "returns false" do
        manager.manager_id.should be_blank
        manager.has_manager?.should be_false
      end
    end
  end

  describe "completed_welcome_tour?" do
    context "complete_welcome_tour present" do
      it "returns true" do
        user.should_receive(:complete_welcome_tour).and_return("true")
        user.completed_welcome_tour?.should be_true
      end
    end

    context "complete_welcome_tour NOT present" do
      it "returns false" do
        user.complete_welcome_tour.should be_blank
        user.completed_welcome_tour?.should be_false
      end
    end
  end
end

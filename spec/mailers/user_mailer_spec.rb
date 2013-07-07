require 'spec_helper'

describe UserMailer do
  let(:user) { users(:test_example_com) }
  let(:manager) { users(:manager_example_com) }

  describe "new_account" do
    context "correct email settings" do
      subject { UserMailer.new_account(user.id).deliver }
      its(:from) { should == ["john@zarlu.com"] }
      its(:to) { should == [user.email] }
      its(:subject) { should == "Help getting started?" }
    end

    context "email is sent" do
      it "ActionMailer receives the email for delivery" do
        expect { UserMailer.new_account(user.id).deliver }.to change(ActionMailer::Base.deliveries, :count).by(1)
      end
    end
  end
end

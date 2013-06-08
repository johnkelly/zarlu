require 'spec_helper'

describe EventMailer do
  let(:event) { events(:build_model) }
  let(:user) { users(:test_example_com) }
  let(:manager) { users(:manager_example_com) }

  describe "pending" do
    context "correct email settings" do
      subject { EventMailer.pending(user.id).deliver }
      its(:from) { should == ["john@zarlu.com"] }
      its(:to) { should == [manager.email] }
      its(:subject) { should == "#{user.display_name} has submitted time off for your approval" }
    end

    context "email is sent" do
      it "ActionMailer receives the email for delivery" do
        expect { EventMailer.pending(user.id).deliver }.to change(ActionMailer::Base.deliveries, :count).by(1)
      end
    end
  end

  describe "approved" do
    context "correct email settings" do
      subject { EventMailer.approved(user.id).deliver }
      its(:from) { should == ["john@zarlu.com"] }
      its(:to) { should == [user.email] }
      its(:subject) { should == "#{manager.display_name} has approved your time off request" }
    end

    context "email is sent" do
      it "ActionMailer receives the email for delivery" do
        expect { EventMailer.approved(user.id).deliver }.to change(ActionMailer::Base.deliveries, :count).by(1)
      end
    end
  end

  describe "rejected" do
    context "correct email settings" do
      subject { EventMailer.rejected(user.id).deliver }
      its(:from) { should == ["john@zarlu.com"] }
      its(:to) { should == [user.email] }
      its(:subject) { should == "#{manager.display_name} has rejected your time off request" }
    end

    context "email is sent" do
      it "ActionMailer receives the email for delivery" do
        expect { EventMailer.rejected(user.id).deliver }.to change(ActionMailer::Base.deliveries, :count).by(1)
      end
    end
  end
end

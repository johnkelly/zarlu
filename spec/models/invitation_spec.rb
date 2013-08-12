require 'spec_helper'

describe Invitation do
  let(:user) { users(:manager_example_com) }

  describe "initialize" do
    it "removes whitespaces and the commas" do
      invitation = Invitation.new("   ghj@example.com,      bnm@example.com  ", user)
      invitation.emails.should == ["ghj@example.com", "bnm@example.com"]
    end

    it "rejects blank emails" do
      invitation = Invitation.new("   ghj@example.com,      bnm@example.com ,  ", user)
      invitation.emails.should == ["ghj@example.com", "bnm@example.com"]
    end

    it "compacts whitespace within an email address" do
      invitation = Invitation.new("   ghj@   example.com,      bnm @example.com", user)
      invitation.emails.should == ["ghj@example.com", "bnm@example.com"]
    end
  end

  describe "mass_send" do
    it "creates two users" do
      invitation = Invitation.new("ghj@example.com, bnm@example.com", user)
      -> { invitation.mass_send }.should change(User, :count).by(2)
    end
  end
end


require 'spec_helper'

describe IncomingMailsController do
  describe "#create" do
    before { post :create, plain: "Hey Matt, \n\nI came down with the flu this morning\n \n-John", headers: { Subject: "05/05/2012" } }

    context "http" do
      it { should respond_with(:success) }
    end

    context "add event to database" do
      subject { assigns[:event] }
      its(:title) { should == "Time off" }
      its(:description) { should == "Hey Matt, \n\nI came down with the flu this morning\n \n-John" }
      its(:starts_at) { should == "Sat, 05 May 2012 07:00:00 UTC +00:00" }
      its(:ends_at) { should == "Sat, 05 May 2012 07:00:00 UTC +00:00" }
      its(:all_day) { should == true }
    end
  end
end

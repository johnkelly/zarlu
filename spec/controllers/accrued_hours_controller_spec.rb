require 'spec_helper'

describe AccruedHoursController do
  let(:manager) { users(:manager_example_com) }
  let(:vacation_leave) { leaves(:leaves_001) }
  let(:sick_leave) { leaves(:leaves_002) }
  let(:holiday_leave) { leaves(:leaves_003) }
  let(:personal_leave) { leaves(:leaves_004) }
  let(:unpaid_leave) { leaves(:leaves_005) }
  let(:other_leave) { leaves(:leaves_006) }
  before { sign_in(manager) }

  describe "#update" do
    context "http" do
      before { put :update, id: vacation_leave.to_param, vacation_leave: { accrued_hours: "4.56" }}
      it { should respond_with(204) }
    end

    context "database" do
      context "vacation" do
        before { put :update, id: vacation_leave.to_param, vacation_leave: { accrued_hours: "4.56" }}
        subject { vacation_leave.reload }
        its(:accrued_hours) { should == 4.56 }
      end

      context "sick" do
        before { put :update, id: sick_leave.to_param, sick_leave: { accrued_hours: "5.6" }}
        subject { sick_leave.reload }
        its(:accrued_hours) { should == 5.6 }
      end

      context "holiday" do
        before { put :update, id: holiday_leave.to_param, holiday_leave: { accrued_hours: "3.6" }}
        subject { holiday_leave.reload }
        its(:accrued_hours) { should == 3.6 }
      end

      context "personal" do
        before { put :update, id: personal_leave.to_param, personal_leave: { accrued_hours: "30.6" }}
        subject { personal_leave.reload }
        its(:accrued_hours) { should == 30.6 }
      end

      context "unpaid" do
        before { put :update, id: unpaid_leave.to_param, unpaid_leave: { accrued_hours: "23.6" }}
        subject { unpaid_leave.reload }
        its(:accrued_hours) { should == 23.6 }
      end

      context "other" do
        before { put :update, id: other_leave.to_param, other_leave: { accrued_hours: "500" }}
        subject { other_leave.reload }
        its(:accrued_hours) { should == 500 }
      end
    end
  end
end

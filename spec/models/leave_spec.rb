require 'spec_helper'

describe Leave do
  let(:user) { users(:manager_example_com) }
  let(:vacation_leave) { leaves(:leaves_001) }

  describe "attributes" do
    it { should belong_to(:user) }
    it { should validate_presence_of(:user_id) }
    it { should validate_numericality_of(:accrued_hours) }
  end

  describe "self.update_accrued_hours" do
    it "only increments the users leave for the kind of leave specified" do
      VacationLeave.any_instance.should_receive(:increment_accrual_hours!).with(4.35).and_return(true)
      SickLeave.any_instance.should_not_receive(:increment_accrual_hours!).with(4.35)
      Leave.update_accrued_hours([user], 4.35, "Vacation")
    end
  end

  describe "increment_accrual_hours!" do
    it "updates the user's accrual hours" do
      vacation_leave.increment_accrual_hours!(5.32)
      vacation_leave.reload.accrued_hours.should == 5.32
    end
  end
end

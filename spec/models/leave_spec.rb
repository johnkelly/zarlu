require 'spec_helper'

describe Leave do
  let(:user) { users(:manager_example_com) }
  let(:vacation_leave) { leaves(:vacation_leave) }

  describe "attributes" do
    it { should belong_to(:user) }
    it { should validate_presence_of(:user_id) }
    it { should validate_numericality_of(:accrued_hours) }
    it { should validate_numericality_of(:used_hours) }
    it { should validate_numericality_of(:pending_hours) }
  end

  describe "self.update_accrued_hours" do
    context "NOT at accrual limit" do
      it "only increments the users leave for the kind of leave specified" do
        VacationLeave.any_instance.stub(:at_accrual_limit?).and_return(false)
        VacationLeave.any_instance.should_receive(:increment_accrual_hours!).with(4.35).and_return(true)
        SickLeave.any_instance.should_not_receive(:increment_accrual_hours!).with(4.35)
        Leave.update_accrued_hours([user], 4.35, "Vacation")
      end
    end

    context "At accrual limit" do
      it "does nothing" do
        VacationLeave.any_instance.stub(:at_accrual_limit?).and_return(true)
        VacationLeave.any_instance.should_not_receive(:increment_accrual_hours!).with(4.35)
        Leave.update_accrued_hours([user], 4.35, "Vacation")
      end
    end
  end

  describe "increment_accrual_hours!" do
    context "accrual will go over limit" do
      it "updates the user's accrual hours" do
        vacation_leave.stub(:accrual_limit).and_return(5)
        vacation_leave.should_receive(:accrual_rate_will_go_over_limit?).with(5.32).and_return(true)
        vacation_leave.increment_accrual_hours!(5.32)
        vacation_leave.reload.accrued_hours.should == 5
      end
    end

    context "accrual will be under limit" do
      it "updates the user's accrual hours" do
        vacation_leave.should_receive(:accrual_rate_will_go_over_limit?).with(5.32).and_return(false)
        vacation_leave.increment_accrual_hours!(5.32)
        vacation_leave.reload.accrued_hours.should == 5.32
      end
    end
  end

  describe "at_accrual_limit?" do
    subject { vacation_leave }

    context "no accrual limit set" do
      before { VacationCompanySetting.any_instance.stub(:accrual_limit).and_return(nil) }
      its(:at_accrual_limit?) { should be_false }
    end

    context "accrual limit set" do
      before { VacationCompanySetting.any_instance.stub(:accrual_limit).and_return(15) }

      context "available time is equal to accrual limit" do
        before { vacation_leave.stub(:available_hours).and_return(15) }
        its(:at_accrual_limit?) { should be_true }
      end

      context "available time is more than accrual limit" do
        before { vacation_leave.stub(:available_hours).and_return(16) }
        its(:at_accrual_limit?) { should be_true }
      end

      context "available time is less than accrual limit" do
        before { vacation_leave.stub(:available_hours).and_return(14) }
        its(:at_accrual_limit?) { should be_false }
      end
    end
  end

  describe "available hours" do
    before { vacation_leave.stub(:accrued_hours).and_return(16) }
    before { vacation_leave.stub(:used_hours).and_return(6.55) }
    subject { vacation_leave }
    its(:available_hours) { should == 9.45 }
  end
end

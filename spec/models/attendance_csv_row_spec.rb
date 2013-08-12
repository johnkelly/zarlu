require 'spec_helper'

describe AttendanceCsvRow do
  let(:attendance_csv) { AttendanceCsvRow.new(email: " unique@example.com ", hire_date: " 04-04-2011 ", vacation_balance: " 50.5 ", sick_balance: " 34.2 ", personal_balance: " 3 ", unpaid_balance: " 4.5 ", other_balance: " 0 ") }
  let(:subscriber) { subscribers(:trial) }
  let(:user) { users(:manager_example_com) }

  describe "attributes" do
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:hire_date) }
    it { should validate_presence_of(:vacation_balance) }
    it { should validate_presence_of(:sick_balance) }
    it { should validate_presence_of(:personal_balance) }
    it { should validate_presence_of(:unpaid_balance) }
    it { should validate_presence_of(:other_balance) }

    it { should validate_numericality_of(:vacation_balance) }
    it { should validate_numericality_of(:sick_balance) }
    it { should validate_numericality_of(:personal_balance) }
    it { should validate_numericality_of(:unpaid_balance) }
    it { should validate_numericality_of(:other_balance) }

    it { should allow_value('04/04/2011').for(:hire_date) }
    it { should allow_value('4-4-2011').for(:hire_date) }
  end

  describe "initialize" do
    subject do
      attendance_csv
    end

    its(:email) { should == "unique@example.com" }
    its(:hire_date) { should == "04-04-2011" }
    its(:vacation_balance) { should == "50.5" }
    its(:sick_balance) { should == "34.2" }
    its(:personal_balance) { should == "3" }
    its(:unpaid_balance) { should == "4.5" }
    its(:other_balance) { should == "0" }
  end

  describe "import" do
    it "invites new user, updates the hire date, and updates accrued_hours" do
      User.any_instance.should_receive(:update!).with({ join_date: Date.new(2011,4,4) })
      VacationLeave.any_instance.should_receive(:update!).with({ accrued_hours: attendance_csv.vacation_balance })
      SickLeave.any_instance.should_receive(:update!).with({ accrued_hours: attendance_csv.sick_balance })
      PersonalLeave.any_instance.should_receive(:update!).with({ accrued_hours: attendance_csv.personal_balance })
      UnpaidLeave.any_instance.should_receive(:update!).with({ accrued_hours: attendance_csv.unpaid_balance })
      OtherLeave.any_instance.should_receive(:update!).with({ accrued_hours: attendance_csv.other_balance })
      -> { attendance_csv.import(subscriber) }.should change(User, :count).by(1)
    end
  end
end

require 'spec_helper'

describe Accrual do
  let(:vacation) { accruals(:vacation_accrual) }

  describe "attributes" do
    it { should belong_to(:subscriber) }
    it { should validate_presence_of(:subscriber_id) }
    it { should validate_numericality_of(:start_year) }
    it { should validate_numericality_of(:end_year) }
    it { should validate_numericality_of(:rate) }
  end

  describe "validation" do
    describe "start year must be less than end year" do
      context "valid" do
        it "returns true for save with no errors" do
          accrual = Accrual.new(start_year: 5, end_year: 10, rate: 4.56, subscriber_id: 1)
          accrual.save.should be_true
          accrual.errors.should be_blank
        end
      end

      context "invalid" do
        subject { Accrual.create(start_year: 10, end_year: 5, rate: 4.56, subscriber_id: 1) }
        its(:errors) { should be_present }
        its(:save) { should be_false }
      end
    end

    describe "accruals can't overlap" do
      context "vacation" do
        context "valid" do
          it "returns true for save with no errors" do
            vacation.start_year.should == 10
            vacation.end_year.should == 15
            accrual = VacationAccrual.new(start_year: 5, end_year: 10, rate: 4.56, subscriber_id: 1)
            accrual.save.should be_true
            accrual.errors.should be_blank
          end
        end

        context "invalid" do
          it "returns false for save with errors since it conflicts with 10-15" do
            vacation.start_year.should == 10
            vacation.end_year.should == 15
            accrual = VacationAccrual.new(start_year: 9, end_year: 84, rate: 4.56, subscriber_id: 1)
            accrual.save.should be_false
            accrual.errors.should be_present
          end
        end
      end

      context "sick" do
        it "can overlap with a vacation accrual of 10-15" do
          vacation.start_year.should == 10
          vacation.end_year.should == 15
          accrual = SickAccrual.new(start_year: 10, end_year: 15, rate: 4.56, subscriber_id: 1)
          accrual.save.should be_true
          accrual.errors.should be_blank
        end
      end
    end
  end
end

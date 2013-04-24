require 'spec_helper'

describe CompanySetting do
  let(:company_setting) { company_settings(:company_settings_001) }

  describe "attributes" do
    it { should belong_to(:subscriber) }
    it { should validate_presence_of(:subscriber_id) }
    it { should validate_numericality_of(:default_accrual_rate) }
  end

  describe "self.accrual_frequencies" do
    it "returns an array of integers and strings" do
      CompanySetting.accrual_frequencies.should == [
        [0, "Year"],
        [1, "Quarter"],
        [2, "Month"],
        [3, "2 weeks"],
        [4, "Week"],
        [5, "Day"]
      ]
    end
  end

  describe "display_start_accrual" do
    context "has start accrual date" do
      it "formats the date as mm/dd/yyyy" do
        company_setting.should_receive(:start_accrual).twice().and_return(Date.today)
        company_setting.display_start_accrual.should == Date.today.strftime('%m-%d-%Y')
      end
    end

    context "no start accrual date" do
      it "does nothing" do
        company_setting.display_start_accrual.should be_nil
      end
    end
  end
end


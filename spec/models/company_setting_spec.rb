require 'spec_helper'

describe CompanySetting do
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
end


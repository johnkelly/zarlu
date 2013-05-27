require 'spec_helper'

describe HolidayCompanySetting do
  let(:subscriber) { subscribers(:trial) }
  let(:holiday_company_setting) { subscriber.holiday_company_setting }

  describe "attributes" do
    it { should belong_to(:subscriber) }
    it { should validate_presence_of(:type) }
    it { should validate_presence_of(:subscriber_id) }
  end

  describe "kind" do
    it "returns an array of holiday and event holiday" do
      holiday_company_setting.kind.should == ["Holiday", Event::HOLIDAY]
    end
  end
end

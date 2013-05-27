require 'spec_helper'

describe VacationCompanySetting do
  let(:subscriber) { subscribers(:trial) }
  let(:vacation_company_setting) { subscriber.vacation_company_setting }

  describe "attributes" do
    it { should belong_to(:subscriber) }
    it { should validate_presence_of(:type) }
    it { should validate_presence_of(:subscriber_id) }
  end

  describe "kind" do
    it "returns an array of vacation and event vacation id" do
      vacation_company_setting.kind.should == ["Vacation", Event::VACATION]
    end
  end
end

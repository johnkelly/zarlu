require 'spec_helper'

describe PersonalCompanySetting do
  let(:subscriber) { subscribers(:trial) }
  let(:personal_company_setting) { subscriber.personal_company_setting }
  describe "attributes" do
    it { should belong_to(:subscriber) }
    it { should validate_presence_of(:type) }
    it { should validate_presence_of(:subscriber_id) }
  end

  describe "kind" do
    it "returns an array of personal and event personal id" do
      personal_company_setting.kind.should == ["Personal", TimeOffValue::PERSONAL]
    end
  end
end

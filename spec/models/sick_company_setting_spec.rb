require 'spec_helper'

describe SickCompanySetting do
  let(:subscriber) { subscribers(:trial) }
  let(:sick_company_setting) { subscriber.sick_company_setting }

  describe "attributes" do
    it { should belong_to(:subscriber) }
    it { should validate_presence_of(:type) }
    it { should validate_presence_of(:subscriber_id) }
  end

  describe "kind" do
    it "returns an array of sick and event sick id" do
      sick_company_setting.kind.should == ["Sick", Event::SICK]
    end
  end
end

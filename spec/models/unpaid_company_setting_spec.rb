require 'spec_helper'

describe UnpaidCompanySetting do
  let(:subscriber) { subscribers(:subscribers_001) }
  let(:unpaid_company_setting) { subscriber.unpaid_company_setting }

  describe "attributes" do
    it { should belong_to(:subscriber) }
    it { should validate_presence_of(:type) }
    it { should validate_presence_of(:subscriber_id) }
  end

  describe "kind" do
    it "returns an array of unpaid and event unpaid id" do
      unpaid_company_setting.kind.should == ["Unpaid", Event::UNPAID]
    end
  end
end

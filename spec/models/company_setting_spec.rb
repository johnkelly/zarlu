require 'spec_helper'

describe CompanySetting do
  describe "attributes" do
    it { should belong_to(:subscriber) }
    it { should validate_presence_of(:subscriber_id) }
    it { should validate_numericality_of(:default_accrual_rate) }
  end
end


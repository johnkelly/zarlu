require 'spec_helper'

describe CompanySetting do
  describe "attributes" do
    it { should belong_to(:subscriber) }
    it { should validate_presence_of(:subscriber_id) }
  end
end


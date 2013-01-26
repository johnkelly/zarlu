require 'spec_helper'

describe User do
  describe "attributes" do
    it { should belong_to(:subscriber) }
    it { should have_many(:events).dependent(:destroy) }
    it { should validate_presence_of(:subscriber_id) }
  end
end

require 'spec_helper'

describe SickAccrual do
  describe "attributes" do
    it { should belong_to(:subscriber) }
    it { should validate_presence_of(:type) }
  end
end

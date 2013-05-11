require 'spec_helper'

describe UnpaidLeave do
  describe "attributes" do
    it { should belong_to(:user) }
    it { should validate_presence_of(:type) }
  end
end



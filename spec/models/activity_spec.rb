require 'spec_helper'

describe Activity do
  describe "associations" do
    it { should belong_to(:user) }
    it { should belong_to(:trackable) }
  end

  describe "validations" do
    it { should validate_presence_of(:user_id) }
    it { should validate_presence_of(:trackable_id) }
  end
end

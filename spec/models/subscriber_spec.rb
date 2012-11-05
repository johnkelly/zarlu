require 'spec_helper'

describe Subscriber do
  describe "attributes" do
    it { should have_many(:users) }
    it { should validate_presence_of(:plan) }
    it { should ensure_inclusion_of(:plan).in_array(['coach', 'business', 'business_select', 'first_class']) }
  end
end

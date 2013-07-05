require 'spec_helper'

describe Holiday do
  let(:holiday) { holidays(:independence_day) }

  describe "attributes" do
    it { should belong_to(:subscriber) }
    it { should validate_presence_of(:subscriber_id) }
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:date) }
  end

  describe "as_json" do
    it "returns holiday as json in correct order" do
      holiday_json = {
        id: holiday.id,
        title: holiday.name,
        description: "",
        start: holiday.date,
        end: holiday.date,
        allDay: true,
        recurring: false,
        color: "#FF5E00",
        approved: true
      }
      holiday.as_json.should == holiday_json
    end
  end
end

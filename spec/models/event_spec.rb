require 'spec_helper'

describe Event do
  let(:event) { events(:build_model) }

  describe "associations" do
    it { should belong_to(:user) }
  end

  describe "validations" do
    it { should validate_presence_of(:user_id) }
  end

  describe "self.date_range" do
    it "returns dates after start date and before end_date" do
      event.starts_at = 30.minutes.ago
      event.ends_at = 90.minutes.ago
      event.save!

      Event.date_range(2.hours.ago, 2.hours.from_now).should == [event]
    end
  end

  describe "as_json" do
    it "returns event as json in correct order" do
      event_json = {
        id: event.id,
        title: event.title,
        description: event.description,
        start: event.starts_at,
        end: event.ends_at,
        allDay: event.all_day,
        recurring: false
      }
      event.as_json.should == event_json
    end
  end
end

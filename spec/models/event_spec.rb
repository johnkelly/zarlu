require 'spec_helper'

describe Event do
  let(:event) { events(:build_model) }

  describe "self.date_range" do
    it "returns dates after start date and before end_date" do
      Event.date_range(2.hours.ago, 2.hours.from_now).should == [event]
    end
  end

  describe "as_json" do
    it "returns event as json in correct order" do
      event_json = {
        id: event.id,
        title: event.title,
        description: event.description,
        start: event.starts_at.rfc822,
        end: event.ends_at.rfc822,
        allDay: event.all_day,
        recurring: false
      }
      event.as_json.should == event_json
    end
  end
end

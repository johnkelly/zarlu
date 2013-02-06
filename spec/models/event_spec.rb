require 'spec_helper'

describe Event do
  let(:event) { events(:build_model) }
  let(:manager) { users(:manager_example_com) }
  let(:user) { users(:test_example_com) }

  describe "associations" do
    it { should belong_to(:user) }
  end

  describe "validations" do
    it { should validate_presence_of(:user_id) }
  end

  describe "callbacks" do
    describe "after_create" do
      context "manager_id nil" do
        it "approves the event" do
          manager.manager_id.should be_nil
          event = manager.events.create!(title: "Build Model", description: "From the lib file", starts_at: 1.minute.from_now, ends_at: 2.hours.from_now)
          event.approved.should be_true
        end
      end

      context "manager_id nil" do
        it "approves the event" do
          user.manager_id.should be_present
          event = user.events.create!(title: "Build Model", description: "From the lib file", starts_at: 1.minute.from_now, ends_at: 2.hours.from_now)
          event.approved.should be_false
        end
      end
    end
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

  describe "approve!" do
    it "should set approved to true" do
      event.approved.should be_false
      event.approve!
      event.reload.approved.should be_true
    end
  end

  describe "reject!" do
    it "should set rejected to true" do
      event.rejected.should be_false
      event.reject!
      event.reload.rejected.should be_true
    end
  end
end

require 'spec_helper'

describe Event do
  let(:event) { events(:build_model) }
  let(:all_day_event) { events(:all_day) }
  let(:manager) { users(:manager_example_com) }
  let(:user) { users(:test_example_com) }

  describe "associations" do
    it { should belong_to(:user) }
  end

  describe "validations" do
    it { should validate_presence_of(:user_id) }
    it { should validate_presence_of(:kind) }
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

      Event.date_range(2.hours.ago, 2.hours.from_now).should include event
    end
  end

  describe "self.kinds" do
    it "returns an array with kind text and value" do
      Event.kinds.should == [
        ["Vacation", Event::VACATION],
        ["Sick", Event::SICK],
        ["Holiday", Event::HOLIDAY],
        ["Personal", Event::PERSONAL],
        ["Unpaid", Event::UNPAID],
        ["Other", Event::OTHER]
      ]
    end
  end

  describe "as_json" do
    context "option passed" do
      it "returns event as json in correct order" do
        event_json = {
          id: event.id,
          title: event.user.display_name,
          description: event.description,
          start: event.starts_at,
          end: event.ends_at,
          allDay: event.all_day,
          recurring: false,
          color: event.color
        }
        event.as_json(display: "email").should == event_json
      end
    end
    context "no option passed" do
      it "returns event as json in correct order" do
        event_json = {
          id: event.id,
          title: event.title,
          description: event.description,
          start: event.starts_at,
          end: event.ends_at,
          allDay: event.all_day,
          recurring: false,
          color: event.color
        }
        event.as_json.should == event_json
      end
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

  describe "color" do
    context "vacation" do
      it "returns blue" do
        event.stub(:kind).and_return(Event::VACATION)
        event.color.should == "#0668C0"
      end
    end

    context "sick" do
      it "returns green" do
        event.stub(:kind).and_return(Event::SICK)
        event.color.should == "green"
      end
    end

    context "holiday" do
      it "returns orange" do
        event.stub(:kind).and_return(Event::HOLIDAY)
        event.color.should == "#FF5E00"
      end
    end

    context "Personal" do
      it "returns purple" do
        event.stub(:kind).and_return(Event::PERSONAL)
        event.color.should == "purple"
      end
    end

    context "Unpaid" do
      it "returns red" do
        event.stub(:kind).and_return(Event::UNPAID)
        event.color.should == "red"
      end
    end

    context "Other" do
      it "returns black" do
        event.stub(:kind).and_return(Event::OTHER)
        event.color.should == "black"
      end
    end
  end

  describe "duration" do
    context "all day event" do
      context "1 day" do
        it "returns 8 hours" do
          all_day_event.duration.should == 8.0
        end
      end

      context "3 days" do
        it "returns 24 hours" do
          all_day_event.stub(:starts_at).and_return((Date.today).midnight)
          all_day_event.stub(:ends_at).and_return((Date.today + 2).midnight)
          all_day_event.duration.should == 24.0
        end
      end

    end

    context "not all day event" do
      context "more than 8 hours" do
        it "returns the number of hours" do
          event.stub(:ends_at).and_return(event.starts_at + 12.hours)
          event.duration.should == 8.0
        end
      end

      context "less than 8 hours" do
        it "returns the number of hours" do
          event.duration.should == 1.98
        end
      end
    end
  end
end

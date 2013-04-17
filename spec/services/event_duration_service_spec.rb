require 'spec_helper'

describe EventDurationService do
  let(:event) { events(:build_model) }

  describe "initialize" do
    context "no events" do
      subject { EventDurationService.new([]) }
      its(:vacation_hours) { should == 0 }
      its(:sick_hours) { should == 0 }
      its(:holiday_hours) { should == 0 }
      its(:personal_hours) { should == 0 }
      its(:unpaid_hours) { should == 0 }
      its(:other_hours) { should == 0 }
    end

    context "some events" do
      subject { EventDurationService.new([event]) }
      its(:vacation_hours) { should == 1.98 }
    end
  end

  describe "unpaid_and_other_hours" do
    it "adds the unpaid and other totals" do
      event_durations = EventDurationService.new([])
      event_durations.should_receive(:unpaid_hours).and_return(16.45)
      event_durations.should_receive(:other_hours).and_return(3.55)
      event_durations.unpaid_and_other_hours.should == 20.00
    end
  end

  describe "pie_chart_data" do
    it "returns an array the event types" do
      event_durations = EventDurationService.new([event])
      event_durations.pie_chart_data.should == [1.98, 0, 0, 0, 0, 0]
    end
  end

  describe "any" do
    context "no events" do
      it "returns false" do
        event_durations = EventDurationService.new([])
        event_durations.any?.should be_false
      end
    end

    context "at least one event" do
      it "returns true" do
        event_durations = EventDurationService.new([event])
        event_durations.any?.should be_true
      end
    end
  end
end

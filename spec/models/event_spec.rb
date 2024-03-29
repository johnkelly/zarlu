require 'spec_helper'

describe Event do
  let(:event) { events(:build_model) }
  let(:all_day_event) { events(:all_day) }
  let(:manager) { users(:manager_example_com) }
  let(:user) { users(:test_example_com) }
  let(:vacation_leave) { user.vacation_leave }

  describe "associations" do
    it { should belong_to(:user) }
  end

  describe "validations" do
    it { should validate_presence_of(:user_id) }
    it { should validate_presence_of(:kind) }
  end

  describe "callbacks" do
    describe "after_create" do
      describe "increment_leave_and_approve_no_manager_leave" do
        describe "increment_pending_leave!" do
          it "increments pending leave" do
            vacation_leave.pending_hours.should == 9.98
            event = user.events.create!(title: "Build Model", description: "From the lib file", starts_at: 1.minute.from_now, ends_at: 2.hours.from_now)
            vacation_leave.reload.pending_hours.should == 11.96
          end
        end

        describe "send_email_or_approve" do
          context "no manager" do
            it "approves the event" do
              manager.manager_id.should be_nil
              event = manager.events.create!(title: "Build Model", description: "From the lib file", starts_at: 1.minute.from_now, ends_at: 2.hours.from_now)
              event.approved.should be_true
            end

            it "does NOT send a pending event email" do
              PendingEventEmailWorker.should_not_receive(:perform_async)
              event = manager.events.create!(title: "Build Model", description: "From the lib file", starts_at: 1.minute.from_now, ends_at: 2.hours.from_now)
            end
          end

          context "has manager" do
            it "does NOT approve the event" do
              user.manager_id.should be_present
              event = user.events.create!(title: "Build Model", description: "From the lib file", starts_at: 1.minute.from_now, ends_at: 2.hours.from_now)
              event.approved.should be_false
            end

            it "sends a pending event email" do
              PendingEventEmailWorker.should_receive(:perform_async).with(user.id)
              event = user.events.create!(title: "Build Model", description: "From the lib file", starts_at: 1.minute.from_now, ends_at: 2.hours.from_now)
            end
          end
        end
      end
    end
  end

  describe "self.date_range" do
    it "returns dates after start date and before end_date" do
      event.update!(starts_at: 90.minutes.ago, ends_at: 30.minutes.ago)
      Event.date_range(2.hours.ago, 2.hours.from_now).should include event
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
          color: event.color,
          approved: event.approved
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
          color: event.color,
          approved: event.approved
        }
        event.as_json.should == event_json
      end
    end
  end

  describe "approve!" do
    before { ApprovedEventEmailWorker.should_receive(:perform_async).with(user.id) }

    it "should set approved to true" do
      event.approved.should be_false
      event.approve!
      event.reload.approved.should be_true
    end

    it "adds the event duration to a users leave" do
      vacation_leave.used_hours.should == 0.0
      event.approve!
      vacation_leave.reload.used_hours.should == event.duration
    end

    it "subtracts the event duration from a users pending leave" do
      vacation_leave.update!(pending_hours: 1.98)
      event.approve!
      vacation_leave.reload.pending_hours.should == 0
    end
  end

  describe "reject!" do
    before { RejectEventEmailWorker.should_receive(:perform_async).with(user.id) }

    it "sets rejected to true" do
      event.rejected.should be_false
      event.reject!
      event.reload.rejected.should be_true
    end

    it "subtracts the event's time from pending" do
      vacation_leave.reload.pending_hours.should == 9.98
      event.reject!
      vacation_leave.reload.pending_hours.should == 8
    end
  end

  describe "unapprove!" do
    context "approved" do
      let(:approved_event) do
        event.update!(approved: true)
        event
      end

      it "should set approved to false" do
        approved_event.unapprove!(1)
        approved_event.reload.approved.should be_false
      end

      it "subtracts the old event duration from a users leave" do
        vacation_leave.used_hours.should == 0.0
        approved_event.unapprove!(1)
        vacation_leave.reload.used_hours.should == -1
      end

      it "add the event duration to a users pending leave" do
        vacation_leave.pending_hours.should == 9.98
        approved_event.unapprove!(1)
        vacation_leave.reload.pending_hours.should == 11.96
      end
    end

    context "not approved" do
      it "does nothing" do
        vacation_leave.used_hours.should == 0.0
        vacation_leave.pending_hours.should == 9.98
        event.unapprove!(1)
        vacation_leave.used_hours.should == 0.0
        vacation_leave.pending_hours.should == 9.98
      end
    end
  end

  describe "cancel!" do
    before { event.should_receive(:decrement_leave!) }

    it "sets the event to canceled" do
      event.cancel!
      event.reload.canceled.should be_true
    end
  end

  describe "color" do
    subject { event }

    context "vacation" do
      before { event.stub(:kind).and_return(TimeOffValue::VACATION) }
      its(:color) { should == "#0668C0" }
    end

    context "sick" do
      before { event.stub(:kind).and_return(TimeOffValue::SICK) }
      its(:color) { should == "green" }
    end

    context "Personal" do
      before { event.stub(:kind).and_return(TimeOffValue::PERSONAL) }
      its(:color) { should == "purple" }
    end

    context "Unpaid" do
      before { event.stub(:kind).and_return(TimeOffValue::UNPAID) }
      its(:color) { should == "red" }
    end

    context "Other" do
      before { event.stub(:kind).and_return(TimeOffValue::OTHER) }
      its(:color) { should == "black" }
    end
  end

  describe "duration" do
    context "all day event" do
      subject { all_day_event }

      context "1 day" do
        its(:duration) { should == 8.0 }
      end

      context "3 days" do
        before do
          all_day_event.stub(:starts_at).and_return((Date.today).midnight)
          all_day_event.stub(:ends_at).and_return((Date.today + 2).midnight)
        end
        its(:duration) { should == 24.0 }
      end
    end

    context "not all day event" do
      subject { event }

      context "more than 8 hours" do
        before { event.stub(:ends_at).and_return(event.starts_at + 12.hours) }
        its(:duration) { should == 8.0 }
      end

      context "less than 8 hours" do
        its(:duration) { should == 1.98 }
      end
    end
  end

  describe "kind_name" do
    subject { event }

    context "vacation" do
      before { event.stub(:kind).and_return(TimeOffValue::VACATION) }
      its(:kind_name) { should == "Vacation" }
    end

    context "sick" do
      before { event.stub(:kind).and_return(TimeOffValue::SICK) }
      its(:kind_name) { should == "Sick" }
    end

    context "personal" do
      before { event.stub(:kind).and_return(TimeOffValue::PERSONAL) }
      its(:kind_name) { should == "Personal" }
    end

    context "unpaid" do
      before { event.stub(:kind).and_return(TimeOffValue::UNPAID) }
      its(:kind_name) { should == "Unpaid" }
    end

    context "other" do
      before { event.stub(:kind).and_return(TimeOffValue::OTHER) }
      its(:kind_name) { should == "Other" }
    end
  end

  describe "update_leave!" do
    context "appoved event and has a manager" do
      it "unapproves the event" do
        event.stub(:approved?).and_return(true)
        event.user.stub(:has_manager?).and_return(true)
        event.should_receive(:unapprove!).with(1)
        event.update_leave!(1)
      end
    end

    context "appoved event and has NO manager" do
      it "subtracts the old event duration and adds the new duration to USED hours" do
        event.approve!
        event.user.stub(:has_manager?).and_return(false)
        vacation_leave.used_hours.should == 1.98
        event.update_leave!(1)
        vacation_leave.reload.used_hours.should == 2.96
      end
    end

    context "unapproved event" do
      it "subtracts the old event duration and adds the new duration to PENDING hours" do
        event.stub(:approved?).and_return(false)
        vacation_leave.pending_hours.should == 9.98
        event.update_leave!(1)
        vacation_leave.reload.pending_hours.should == 10.96
      end
    end
  end

  describe "decrement_leave!" do
    describe "decrement_leave usage" do
      context "approved event" do
        it "decrements used leave" do
          event.approve!
          vacation_leave.used_hours.should == 1.98
          event.decrement_leave!
          vacation_leave.reload.used_hours.should == 0.0
        end
      end

      context "unapproved event" do
        it "does nothing" do
          event.approved?.should be_false
          vacation_leave.stub(:used_hours).and_return(1.98)
          event.decrement_leave!
          vacation_leave.reload.used_hours.should == 1.98
        end
      end
    end

    describe "decrement pending usage" do
      context "approved event" do
        it "does nothing" do
          event.approve!
          vacation_leave.stub(:pending_hours).and_return(1.98)
          event.decrement_leave!
          vacation_leave.reload.pending_hours.should == 1.98
        end
      end

      context "unapproved event" do
        it "decrement pending leave" do
          event.approved?.should be_false
          vacation_leave.update(pending_hours: 1.98)
          event.decrement_leave!
          vacation_leave.reload.pending_hours.should == 0
        end
      end
    end
  end
end

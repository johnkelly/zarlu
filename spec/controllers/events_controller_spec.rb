require 'spec_helper'

describe EventsController do
  let(:event) { events(:build_model) }
  let(:all_day_event) { events(:all_day) }
  let(:cancel_event) { events(:canceled) }
  let(:rejected_event) { events(:rejected) }
  let(:user) { users(:test_example_com) }
  let(:manager) { users(:manager_example_com) }

  before { sign_in(user) }

  describe "index" do
    context "with start and end params" do
      before { get :index, start: event.starts_at, end: event.ends_at, format: :json }
      it { should respond_with(:success) }
      it { assigns(:events).should include(event) }
      it { assigns(:events).should_not include(cancel_event) }
      it { assigns(:events).should_not include(rejected_event) }
    end

    context "no params" do
      before { get :index, format: :json }
      it { should respond_with(:success) }
      it { assigns(:events).should == Event.none }
    end
  end

  describe "manager" do
    context "Manager with employees & with start and end params" do
      before do
        sign_out(user)
        sign_in(manager)
        get :manager, start: event.starts_at, end: event.ends_at, format: :json
      end
      it { should respond_with(:success) }
      it "allows manager to view employee events " do
        manager.employees.should include(user)
      end
      it { assigns(:events).should include(event) }
      it { assigns(:events).should_not include(cancel_event) }
      it { assigns(:events).should_not include(rejected_event) }
    end

    context "No employees & with start and end params" do
      before { get :manager, start: event.starts_at, end: event.ends_at, format: :json }
      it { should respond_with(:success) }
      it "user has no employees" do
        user.employees.should be_blank
      end
      it { assigns(:events).should == Event.none }
    end

    context "no params" do
      before { get :manager, format: :json }
      it { should respond_with(:success) }
      it { assigns(:events).should == Event.none }
    end
  end

  describe "company" do
    context "with start and end params" do
      before { get :company, start: event.starts_at, end: event.ends_at, format: :json }
      it { should respond_with(:success) }
      it { assigns(:events).should include(event) }
      it { assigns(:events).should_not include(cancel_event) }
      it { assigns(:events).should_not include(rejected_event) }
    end

    context "no params" do
      before { get :company, format: :json }
      it { should respond_with(:success) }
      it { assigns(:events).should == Event.none }
    end
  end

  describe "create" do
    before do
      @starts_at = 12.hours.from_now
      @ends_at = 13.hours.from_now
      ApplicationController.any_instance.should_receive(:track_activity!)
      post :create, event: { title: "Brand New", starts_at: @starts_at, ends_at: @ends_at }, format: :json
    end

    context "http" do
      it { should respond_with(:success) }
    end

    context "add event to database" do
      subject { assigns[:event] }
      its(:starts_at) { should == @starts_at }
      its(:ends_at) { should == @ends_at }
    end
  end

  describe "update" do
    before { ApplicationController.any_instance.should_receive(:track_activity!) }

    context "http" do
      before { put :update, id: event.to_param, event: { starts_at: 12.hours.from_now, ends_at: 13.hours.from_now }, format: :json }
      it { should respond_with(:success) }
      it { assigns(:event).should == event }
    end

    context "update database" do
      before do
        Event.any_instance.should_receive(:update_leave!).with(1.98)
        @starts_at = 12.hours.from_now
        @ends_at = 13.hours.from_now
        put :update, id: event.to_param, event: { starts_at: @starts_at, ends_at: @ends_at }, format: :json
      end

      it "saves the start time in utc" do
        event.reload.starts_at.to_i.should == @starts_at.to_i
      end

      it "saves the end time in utc" do
        event.reload.ends_at.to_i.should == @ends_at.to_i
      end
    end
  end

  describe "#destroy" do
    before do
      ApplicationController.any_instance.should_receive(:track_activity!)
      Event.any_instance.should_receive(:cancel!)
    end

    context "http" do
      before { delete :destroy, id: event.to_param, format: :json }
      it { should respond_with(:success) }
      it { assigns(:event).should == event }
    end

    context "database" do
      it "does NOT delete the record" do
        -> { delete :destroy, id: event.to_param, format: :json }.should_not change(Event, :count)
      end
    end
  end
end

require 'spec_helper'

describe EventsController do
  let(:event) { events(:build_model) }

  describe "index" do
    context "with start and end params" do
      before { get :index, start: event.starts_at, end: event.ends_at, format: :json }
      it { should respond_with(:success) }
      it { should respond_with_content_type(/json/) }
      it { should assign_to(:events).with([event]) }
    end

    context "no params" do
      before { get :index, format: :json }
      it { should respond_with(:success) }
      it { should respond_with_content_type(/json/) }
      it { should assign_to(:events).with([]) }
    end
  end

  describe "create" do
    before do
      @starts_at = 12.hours.from_now
      @ends_at = 13.hours.from_now
      post :create, event: { title: "Brand New", starts_at: @starts_at, ends_at: @ends_at }, format: :json
    end

    context "http" do
      it { should respond_with(:success) }
      it { should respond_with_content_type(/json/) }
    end

    context "add event to database" do
      subject { assigns[:event] }
      its(:starts_at) { should == @starts_at }
      its(:ends_at) { should == @ends_at }
    end
  end

  describe "update" do
    context "http" do
      before { put :update, id: event.to_param, event: { starts_at: 12.hours.from_now, ends_at: 13.hours.from_now }, format: :json }
      it { should respond_with(:success) }
      it { should respond_with_content_type(/json/) }
      it { should assign_to(:event).with(event) }
    end

    context "update database" do
      before do
        @starts_at = 12.hours.from_now
        @ends_at = 13.hours.from_now
        put :update, id: event.to_param, event: { starts_at: @starts_at, ends_at: @ends_at }, format: :json
      end

      it "saves the start time in utc" do
        event.reload.starts_at.to_i.should == @starts_at.to_i - 8.hours.to_i
      end

      it "saves the end time in utc" do
        event.reload.ends_at.to_i.should == @ends_at.to_i - 8.hours.to_i
      end
    end
  end

  describe "#destroy" do
    context "http" do
      before { delete :destroy, id: event.to_param, format: :json}
      it { should respond_with(:success) }
      it { should assign_to(:event).with(event) }
    end

    context "database" do
      it "deletes the record" do
        -> { delete :destroy, id: event.to_param, format: :json }.should change(Event, :count).by(-1)
      end
    end
  end
end

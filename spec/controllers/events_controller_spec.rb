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

      subject { event.reload }
      its(:starts_at) { should == @starts_at }
      its(:ends_at) { should == @ends_at }
    end
  end
end

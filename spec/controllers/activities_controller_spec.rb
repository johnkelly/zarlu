require 'spec_helper'

describe ActivitiesController do
  let(:user) { users(:test_example_com) }
  before { sign_in(user) }

  describe "#index" do
    context "user" do
      before { get :index }
      it { should respond_with(:success) }
      it { should assign_to(:level_of_activity).with("user") }
      it { should assign_to(:activities).with(user.activities.order("created_at desc").limit(50)) }
    end

    context "manager" do
      before { get :index, activity_type: "manager" }
      it { should respond_with(:success) }
      it { should assign_to(:level_of_activity).with("manager") }
      it { should assign_to(:activities).with(Activity.order("created_at desc").where(user_id: []).limit(50)) }
    end

    context "company" do
      before { get :index, activity_type: "company" }
      it { should respond_with(:success) }
      it { should assign_to(:level_of_activity).with("company") }
      it { should assign_to(:activities).with(Activity.order("created_at desc").where(user_id: [user.subscriber.users.collect(&:id)]).limit(50)) }
    end
  end
end

require 'spec_helper'

describe ActivitiesController do
  let(:user) { users(:test_example_com) }
  let(:subscriber) { subscribers(:trial) }
  before { sign_in(user) }

  describe "#index" do
    context "user" do
      before { get :index }
      it { should respond_with(:success) }
      it { assigns(:subscriber).should == subscriber }
      it { assigns(:level_of_activity).should == "user" }
      it { assigns(:activities).should == user.activities.order("created_at desc").paginate(page: 1, per_page: 30) }
    end

    context "manager" do
      before { get :index, activity_type: "manager" }
      it { should respond_with(:success) }
      it { assigns(:subscriber).should == subscriber }
      it { assigns(:level_of_activity).should == "manager" }
      it { assigns(:activities).should == Activity.order("created_at desc").where(user_id: []).paginate(page: 1, per_page: 30) }
    end

    context "company" do
      before { get :index, activity_type: "company" }
      it { should respond_with(:success) }
      it { assigns(:subscriber).should == subscriber }
      it { assigns(:level_of_activity).should == "company" }
      it { assigns(:activities).should == Activity.order("created_at desc").where(user_id: [user.subscriber.users.collect(&:id)]).paginate(page: 1, per_page: 30) }
    end
  end
end

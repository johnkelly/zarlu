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
      it { assigns(:level).should == "user" }
      it { assigns(:activities).should == Activity.where(user_id: user).lifo.paginate(page: 1, per_page: 30) }
    end

    context "manager" do
      before { get :index, activity_type: "manager" }
      it { should respond_with(:success) }
      it { assigns(:subscriber).should == subscriber }
      it { assigns(:level).should == "manager" }
      it { assigns(:activities).should == [] }
    end

    context "company" do
      before { get :index, activity_type: "company" }
      it { should respond_with(:success) }
      it { assigns(:subscriber).should == subscriber }
      it { assigns(:level).should == "company" }
      it { assigns(:activities).should == Activity.where(user_id: subscriber.users.map(&:id)).lifo.paginate(page: 1, per_page: 30) }
    end
  end
end

require 'spec_helper'

describe LeavesController do
  let(:user) { users(:test_example_com) }
  let(:vacation_leave) { user.vacation_leave }
  let(:sick_leave) { user.sick_leave }
  let(:personal_leave) { user.personal_leave }
  let(:unpaid_leave) { user.unpaid_leave }
  let(:other_leave) { user.other_leave }

  before { sign_in(user) }

  describe "#show" do
    context "vacation" do
      before { get :show, kind: TimeOffValue::VACATION, format: :json }
      it { should respond_with(:success) }
      it { assigns(:leave).should == vacation_leave }
    end

    context "sick" do
      before { get :show, kind: TimeOffValue::SICK, format: :json }
      it { should respond_with(:success) }
      it { assigns(:leave).should == sick_leave }
    end

    context "personal" do
      before { get :show, kind: TimeOffValue::PERSONAL, format: :json }
      it { should respond_with(:success) }
      it { assigns(:leave).should == personal_leave }
    end

    context "unpaid" do
      before { get :show, kind: TimeOffValue::UNPAID, format: :json }
      it { should respond_with(:success) }
      it { assigns(:leave).should == unpaid_leave }
    end

    context "other" do
      before { get :show, kind: TimeOffValue::OTHER, format: :json }
      it { should respond_with(:success) }
      it { assigns(:leave).should == other_leave }
    end
  end
end

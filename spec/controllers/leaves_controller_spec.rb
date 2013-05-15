require 'spec_helper'

describe LeavesController do
  let(:user) { users(:test_example_com) }
  let(:vacation_leave) { leaves(:leaves_007) }
  let(:sick_leave) { leaves(:leaves_008) }
  let(:holiday_leave) { leaves(:leaves_009) }
  let(:personal_leave) { leaves(:leaves_010) }
  let(:unpaid_leave) { leaves(:leaves_011) }
  let(:other_leave) { leaves(:leaves_012) }

  before { sign_in(user) }

  describe "#show" do
    context "vacation" do
      before { get :show, kind: "0", format: :json }
      it { should respond_with(:success) }
      it { assigns(:leave).should == vacation_leave }
    end

    context "sick" do
      before { get :show, kind: "1", format: :json }
      it { should respond_with(:success) }
      it { assigns(:leave).should == sick_leave }
    end

    context "holiday" do
      before { get :show, kind: "2", format: :json }
      it { should respond_with(:success) }
      it { assigns(:leave).should == holiday_leave }
    end

    context "personal" do
      before { get :show, kind: "3", format: :json }
      it { should respond_with(:success) }
      it { assigns(:leave).should == personal_leave }
    end

    context "unpaid" do
      before { get :show, kind: "4", format: :json }
      it { should respond_with(:success) }
      it { assigns(:leave).should == unpaid_leave }
    end

    context "other" do
      before { get :show, kind: "5", format: :json }
      it { should respond_with(:success) }
      it { assigns(:leave).should == other_leave }
    end
  end
end

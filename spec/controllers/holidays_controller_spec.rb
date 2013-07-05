require 'spec_helper'

describe HolidaysController do
  let(:manager) { users(:manager_example_com) }
  let(:holiday) { holidays(:independence_day) }
  let(:holiday_2) { holidays(:christmas_day) }
  before { sign_in(manager) }

  describe "index" do
    context "with start and end params" do
      before { get :index, start: DateTime.new(Date.current.year, 7, 1).to_i, end: DateTime.new(Date.current.year, 7, 30).to_i, format: :json }
      it { should respond_with(:success) }
      it { assigns(:holidays).should include(holiday) }
      it { assigns(:holidays).should_not include(holiday_2) }
    end

    context "no params" do
      before { get :index, format: :json }
      it { should respond_with(:success) }
      it { assigns(:holidays).should == Holiday.none }
    end
  end

  describe "#create" do
    context "http" do
      context "success" do
        before { post :create, holiday: { name: "Labor Day", date: "12/25/2013" }}
        it { should redirect_to company_settings_url }
        it { should set_the_flash[:notice] }
        it { assigns(:subscriber).should == manager.subscriber }
      end

      context "error" do
        before { post :create, holiday: { name: "", date: "9/2/2013" }}
        it { should redirect_to company_settings_url }
        it { should set_the_flash[:alert] }
        it { assigns(:subscriber).should == manager.subscriber }
      end
    end

    context "database" do
      context "vacation" do
        it "creates a new vacation accrual" do
          -> { post :create, holiday: { name: "Labor Day", date: "12/25/2013" }}.should change(Holiday, :count).by(1)
        end
      end
    end
  end

  describe "#destroy" do
    context "http" do
      before { delete :destroy, id: holiday.to_param }
      it { should redirect_to company_settings_url }
      it { assigns(:subscriber).should == manager.subscriber }
      it { assigns(:holiday).should == holiday }
      it { should set_the_flash[:notice] }
    end

    context "database" do
      it "deletes an accrual" do
        -> { delete :destroy, id: holiday.to_param }.should change(Holiday, :count).by(-1)
      end
    end
  end
end

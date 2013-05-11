require 'spec_helper'

describe CompanySettingsController do
  let(:manager) { users(:manager_example_com) }
  let(:subscriber) { subscribers(:subscribers_001) }
  let(:company_setting_service) { mock("CompanySettingService") }
  let(:vacation) { subscriber.vacation_company_setting }
  let(:sick) { subscriber.sick_company_setting }
  let(:holiday) { subscriber.holiday_company_setting }
  let(:personal) { subscriber.personal_company_setting }
  let(:unpaid) { subscriber.unpaid_company_setting }
  let(:other) { subscriber.other_company_setting }
  before { sign_in(manager) }

  describe "#index" do
    before do
      CompanySettingService.should_receive(:new).with(subscriber.company_settings).and_return(company_setting_service)
      get :index
    end
    it { should respond_with(:success) }
    it { assigns(:subscriber).should == subscriber }
    it { assigns(:company_setting_service).should == company_setting_service }
    it { assigns(:time_zones).should == ActiveSupport::TimeZone.all.map{ |tz| [tz.name, tz.name] }}
  end

  describe "#update" do
    context "http" do
      before { patch :update, id: vacation.to_param, vacation_company_setting: { enabled: "true" }}
      it { should respond_with(204) }
    end

    context "database" do
      context "vacation" do
        before do
          subscriber.vacation_company_setting.enabled.should be_true
          patch :update, id: vacation.to_param, vacation_company_setting: { enabled: "false" }
        end
        subject { subscriber.vacation_company_setting.reload }
        its(:enabled) { should be_false }
      end

      context "sick" do
        before do
          subscriber.sick_company_setting.enabled.should be_true
          patch :update, id: sick.to_param, sick_company_setting: { enabled: "false" }
        end
        subject { subscriber.sick_company_setting.reload }
        its(:enabled) { should be_false }
      end

      context "holiday" do
        before do
          subscriber.holiday_company_setting.enabled.should be_true
          patch :update, id: holiday.to_param, holiday_company_setting: { enabled: "false" }
        end
        subject { subscriber.holiday_company_setting.reload }
        its(:enabled) { should be_false }
      end

      context "personal" do
        before do
          subscriber.personal_company_setting.enabled.should be_true
          patch :update, id: personal.to_param, personal_company_setting: { enabled: "false" }
        end
        subject { subscriber.personal_company_setting.reload }
        its(:enabled) { should be_false }
      end

      context "unpaid" do
        before do
          subscriber.unpaid_company_setting.enabled.should be_true
          patch :update, id: unpaid.to_param, unpaid_company_setting: { enabled: "false" }
        end
        subject { subscriber.unpaid_company_setting.reload }
        its(:enabled) { should be_false }
      end

      context "other" do
        before do
          subscriber.other_company_setting.enabled.should be_true
          patch :update, id: other.to_param, other_company_setting: { enabled: "false" }
        end
        subject { subscriber.other_company_setting.reload }
        its(:enabled) { should be_false }
      end

      context "update date" do
        before do
          subscriber.other_company_setting.next_accrual.should be_present
          patch :update, id: other.to_param, other_company_setting: { next_accrual: "10/01/1987" }
        end
        subject { subscriber.other_company_setting.reload }
        its(:next_accrual) { should ==  Date.strptime("10/01/1987", "%m/%d/%Y") }
      end
    end
  end
end

require 'spec_helper'

describe CompanySettingService do
  let(:subscriber) { subscribers(:subscribers_001) }
  let(:vacation) { subscriber.vacation_company_setting }
  let(:sick) { subscriber.sick_company_setting }
  let(:holiday) { subscriber.holiday_company_setting }
  let(:personal) { subscriber.personal_company_setting }
  let(:unpaid) { subscriber.unpaid_company_setting }
  let(:other) { subscriber.other_company_setting }

  describe "initialize" do
    subject { CompanySettingService.new(subscriber.company_settings) }
    its(:vacation) { should == vacation }
    its(:sick) { should == sick }
    its(:holiday) { should == holiday }
    its(:personal) { should == personal }
    its(:unpaid) { should == unpaid }
    its(:other) { should == other }
  end
end

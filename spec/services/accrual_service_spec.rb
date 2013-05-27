require 'spec_helper'

describe AccrualService do
  let(:subscriber) { subscribers(:trial) }
  let(:vacation) { subscriber.vacation_accruals }
  let(:sick) { subscriber.sick_accruals }
  let(:holiday) { subscriber.holiday_accruals }
  let(:personal) { subscriber.personal_accruals }
  let(:unpaid) { subscriber.unpaid_accruals }
  let(:other) { subscriber.other_accruals }

  describe "initialize" do
    subject { AccrualService.new(subscriber.accruals) }
    its(:vacation) { should == vacation }
    its(:sick) { should == sick }
    its(:holiday) { should == holiday }
    its(:personal) { should == personal }
    its(:unpaid) { should == unpaid }
    its(:other) { should == other }
  end
end

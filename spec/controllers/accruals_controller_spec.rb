require 'spec_helper'

describe AccrualsController do
  let(:manager) { users(:manager_example_com) }
  let(:accrual) { accruals(:vacation_accrual) }
  before { sign_in(manager) }

  describe "#create" do
    context "http" do
      context "success" do
        before { post :create, accrual: { start_year: "0", end_year: "2", rate: "5.67" }}
        it { should redirect_to company_settings_url }
        it { should set_the_flash[:notice] }
        it { assigns(:subscriber).should == manager.subscriber }
      end

      context "error" do
        before { post :create, accrual: { start_year: "0A", end_year: "2", rate: "5.67" }}
        it { should redirect_to company_settings_url }
        it { should set_the_flash[:alert] }
        it { assigns(:subscriber).should == manager.subscriber }
      end
    end

    context "database" do
      context "vacation" do
        it "creates a new vacation accrual" do
          -> { post :create, accrual: { start_year: "0", end_year: "2", rate: "5.67" }, type: TimeOffValue::VACATION }.should change(VacationAccrual, :count).by(1)
        end
      end

      context "sick" do
        it "creates a new sick accrual" do
          -> { post :create, accrual: { start_year: "0", end_year: "2", rate: "5.67" }, type: TimeOffValue::SICK }.should change(SickAccrual, :count).by(1)
        end
      end

      context "personal" do
        it "creates a new personal accrual" do
          -> { post :create, accrual: { start_year: "0", end_year: "2", rate: "5.67" }, type: TimeOffValue::PERSONAL }.should change(PersonalAccrual, :count).by(1)
        end
      end

      context "unpaid" do
        it "creates a new unpaid accrual" do
          -> { post :create, accrual: { start_year: "0", end_year: "2", rate: "5.67" }, type: TimeOffValue::UNPAID }.should change(UnpaidAccrual, :count).by(1)
        end
      end

      context "other" do
        it "creates a new other accrual" do
          -> { post :create, accrual: { start_year: "0", end_year: "2", rate: "5.67" }, type: TimeOffValue::OTHER }.should change(OtherAccrual, :count).by(1)
        end
      end
    end
  end

  describe "#destroy" do
    context "http" do
      before { delete :destroy, id: accrual.to_param }
      it { should redirect_to company_settings_url }
      it { assigns(:subscriber).should == manager.subscriber }
      it { assigns(:accrual).should == accrual }
      it { should set_the_flash[:notice] }
    end

    context "database" do
      it "deletes an accrual" do
        -> { delete :destroy, id: accrual.to_param }.should change(Accrual, :count).by(-1)
      end
    end
  end
end

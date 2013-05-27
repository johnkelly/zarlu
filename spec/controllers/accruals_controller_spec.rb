require 'spec_helper'

describe AccrualsController do
  let(:manager) { users(:manager_example_com) }
  let(:accrual) { accruals(:vacation_accrual) }
  before { sign_in(manager) }

  describe "#create" do
    context "http" do
      context "success" do
        before { post :create, vacation_accrual: { start_year: "0", end_year: "2", rate: "5.67" }}
        it { should redirect_to company_settings_url }
        it { should set_the_flash[:notice] }
        it { assigns(:subscriber).should == manager.subscriber }
      end

      context "error" do
        before { post :create, vacation_accrual: { start_year: "0A", end_year: "2", rate: "5.67" }}
        it { should redirect_to company_settings_url }
        it { should set_the_flash[:alert] }
        it { assigns(:subscriber).should == manager.subscriber }
      end
    end

    context "database" do
      context "vacation" do
        it "creates a new vacation accrual" do
          -> { post :create, vacation_accrual: { start_year: "0", end_year: "2", rate: "5.67" }, type: Event::VACATION }.should change(VacationAccrual, :count).by(1)
        end
      end

      context "sick" do
        it "creates a new sick accrual" do
          -> { post :create, sick_accrual: { start_year: "0", end_year: "2", rate: "5.67" }, type: Event::SICK }.should change(SickAccrual, :count).by(1)
        end
      end

      context "holiday" do
        it "creates a new holiday accrual" do
          -> { post :create, holiday_accrual: { start_year: "0", end_year: "2", rate: "5.67" }, type: Event::HOLIDAY }.should change(HolidayAccrual, :count).by(1)
        end
      end

      context "personal" do
        it "creates a new personal accrual" do
          -> { post :create, personal_accrual: { start_year: "0", end_year: "2", rate: "5.67" }, type: Event::PERSONAL }.should change(PersonalAccrual, :count).by(1)
        end
      end

      context "unpaid" do
        it "creates a new unpaid accrual" do
          -> { post :create, unpaid_accrual: { start_year: "0", end_year: "2", rate: "5.67" }, type: Event::UNPAID }.should change(UnpaidAccrual, :count).by(1)
        end
      end

      context "other" do
        it "creates a new other accrual" do
          -> { post :create, other_accrual: { start_year: "0", end_year: "2", rate: "5.67" }, type: Event::OTHER }.should change(OtherAccrual, :count).by(1)
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

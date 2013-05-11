require 'spec_helper'

describe CompanySetting do
  let(:company_setting) { company_settings(:company_settings_001) }

  describe "attributes" do
    it { should belong_to(:subscriber) }
    it { should validate_presence_of(:subscriber_id) }
    it { should validate_numericality_of(:default_accrual_rate) }
  end

  describe "validation" do
    it "sets a default accrual frequency and start accrual date" do
      new_setting = CompanySetting.new(subscriber_id: company_setting.subscriber_id)
      new_setting.should be_valid
    end
  end

  describe "self.accrual_frequencies" do
    it "returns an array of integers and strings" do
      CompanySetting.accrual_frequencies.should == [
        [0, "Year"],
        [1, "Quarter"],
        [2, "Month"],
        [3, "2 weeks"],
        [4, "Week"],
        [5, "Day"]
      ]
    end
  end

  describe "self.update_accrual_hours" do
    context "all settings are accruing today" do
      before { CompanySetting.any_instance.stub(:accrues_today?).and_return(true) }

      it "creates a worker for each company setting" do
        UpdateAccrualWorker.should_receive(:perform_async).exactly(CompanySetting.all.count).times
        CompanySetting.update_accrual_hours
      end

      it "updates the accrual hours for each setting" do
        Leave.should_receive(:update_accrued_hours).exactly(CompanySetting.all.count).times
        CompanySetting.update_accrual_hours
      end
    end

    context "no settings are accruing today" do
      before { CompanySetting.any_instance.stub(:accrues_today?).and_return(false) }

      it "creates no workers" do
        UpdateAccrualWorker.should_not_receive(:perform_async)
        CompanySetting.update_accrual_hours
      end

      it "does not update accrual hours" do
        Leave.should_not_receive(:update_accrued_hours)
        CompanySetting.update_accrual_hours
      end
    end
  end

  describe "display_next_accrual" do
    context "has start accrual date" do
      it "formats the date as mm/dd/yyyy" do
        company_setting.should_receive(:next_accrual).and_return(Date.today)
        company_setting.display_next_accrual.should == Date.today.strftime('%m-%d-%Y')
      end
    end
  end

  describe "accrues_today?" do
    context "next_accrual date is today" do
      it "returns true" do
        company_setting.should_receive(:next_accrual).and_return(Date.today)
        company_setting.accrues_today?.should be_true
      end
    end

    context "next_accrual date is NOT today" do
      it "returns true" do
        company_setting.should_receive(:next_accrual).and_return(1.day.ago)
        company_setting.accrues_today?.should be_false
      end
    end
  end

  describe "set_next_accrual_date!" do
    it "updates the accrual date" do
      old_accrual_date = Date.today
      company_setting.set_next_accrual_date!
      company_setting.reload.next_accrual.should == old_accrual_date + 1.year
    end
  end
end


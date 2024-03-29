require 'spec_helper'

describe User do
  let(:manager) { users(:manager_example_com) }
  let(:user) { users(:test_example_com) }
  let(:subscriber) { subscribers(:trial) }

  describe "attributes" do
    it { should belong_to(:subscriber) }
    it { should have_many(:events).dependent(:destroy) }
    it { should have_many(:activities).dependent(:destroy) }
    it { should have_many(:leaves).dependent(:destroy) }
    it { should validate_presence_of(:subscriber_id) }
  end

  describe "after_create" do
    it "creates a vacation company setting record" do
      -> { subscriber.users.create!(email: "t1@e.com", password: "password", password_confirmation: "password")}.should change(VacationLeave, :count).by(1)
      -> { subscriber.users.create!(email: "t2@e.com", password: "password", password_confirmation: "password")}.should change(SickLeave, :count).by(1)
      -> { subscriber.users.create!(email: "t4@e.com", password: "password", password_confirmation: "password")}.should change(PersonalLeave, :count).by(1)
      -> { subscriber.users.create!(email: "t5@e.com", password: "password", password_confirmation: "password")}.should change(UnpaidLeave, :count).by(1)
      -> { subscriber.users.create!(email: "t6@e.com", password: "password", password_confirmation: "password")}.should change(OtherLeave, :count).by(1)
    end
  end

  describe "before_destroy" do
    context "manager" do
      context "more than one manager" do
        before do
          subscriber.users.create!(email: "manager2@example.com", password: "password", password_confirmation: "password", manager: true)
          User.any_instance.should_receive(:stop_charging_subscriber)
        end

        it "calls demote to employee" do
          manager.manager.should be_true
          manager.should_receive(:demote_to_employee!)
          manager.destroy!
        end
      end

      context "only one manager" do
        context "no employees" do
          before do
            user.stub(:stop_charging_subscriber)
            user.destroy!
            manager.should_receive(:stop_charging_subscriber)
          end

          it "calls demote to employee" do
            manager.manager.should be_true
            manager.should_receive(:demote_to_employee!)
            manager.destroy!
          end
        end

        context "with employees" do
          it "returns false with errors" do
            manager.manager.should be_true
            manager.destroy.should be_false
            manager.errors.should be_present
          end
        end
      end
    end

    context "not manager" do
      it "does nothing" do
        user.manager.should be_false
        user.should_not_receive(:demote_to_employee!)
        user.should_receive(:stop_charging_subscriber)
        user.destroy!
      end
    end
  end

  describe "after_destroy" do
    it "calls ChargeCreditCardWorker" do
      ChargeCreditCardWorker.should_receive(:perform_async).with(user.subscriber_id)
      user.destroy!
    end
  end

  describe "promote to manager!" do
    it "sets the user's manager attribute to true" do
      user.manager.should be_false
      user.promote_to_manager!
      user.reload.manager.should be_true
    end
  end

  describe "demote to employee!" do
    it "sets all the manager's employees to no manager" do
      manager.employees.should == [user]
      manager.demote_to_employee!
      manager.reload.employees.should == []
    end

    it "sets the manager's manager attribute to false" do
      manager.manager?.should be_true
      manager.demote_to_employee!
      manager.reload.manager?.should be_false
    end
  end

  describe "employees" do
    context "no employees" do
      subject { user }
      its(:employees) { should be_empty }
    end

    context "has employees" do
      subject { manager }
      its(:employees) { should == [user] }
    end
  end

  describe "has_manager?" do
    context "user with a manager id" do
      it "returns true" do
        user.manager_id.should be_present
        user.has_manager?.should be_true
      end
    end

    context "user without a manager id" do
      it "returns false" do
        manager.manager_id.should be_blank
        manager.has_manager?.should be_false
      end
    end
  end

  describe "completed_welcome_tour?" do
    context "complete_welcome_tour present" do
      it "returns true" do
        user.should_receive(:complete_welcome_tour).and_return("true")
        user.completed_welcome_tour?.should be_true
      end
    end

    context "complete_welcome_tour NOT present" do
      it "returns false" do
        user.complete_welcome_tour.should be_blank
        user.completed_welcome_tour?.should be_false
      end
    end
  end

  describe "open_support_tool?" do
    subject { user }

    context "open_support_tool present" do
      before { user.stub(:open_support_tool).and_return("true") }
      its(:open_support_tool?) { should == true }
    end

    context "open_support_tool NOT present" do
      its(:open_support_tool) { should be_blank }
      its(:open_support_tool?) { should == false }
    end
  end

  describe "display_name" do
    context "name is present" do
      it "returns user's name" do
        user.stub(:name).and_return("john locke")
        user.display_name.should == "John Locke"
      end
    end

    context "name NOT present" do
      it "returns user's email" do
        user.stub(:name).and_return(nil)
        user.display_name.should == "Test@example.com"
      end
    end
  end

  describe "change_manager!" do
    context "Manager id -1" do
      it "sets the user's manager id to nil" do
        user.manager_id.should be_present
        user.change_manager!(-1)
        user.reload.manager_id.should be_blank
      end
    end

    context "any other manager id" do
      it "sets the user's manager id to the manager id" do
        user.update_column(:manager_id, nil)
        user.manager_id.should be_blank
        user.change_manager!(manager.id)
        user.reload.manager_id.should == manager.id
      end
    end
  end

  describe "display_join_date" do
    it "display the join date in the american date format" do
      user.stub(:join_date).and_return(Date.new(2011,04,04))
      user.display_join_date.should == "04/04/2011"
    end
  end

  describe "first_sign_in?" do
    subject { user }
    context "only one sign in" do
      before { user.stub(:sign_in_count).and_return(1) }
      its(:first_sign_in?) { should be_true }
    end
    context "more than one sign in" do
      before { user.stub(:sign_in_count).and_return(2) }
      its(:first_sign_in?) { should be_false }
    end
  end

  describe "years at company" do
    context "has join date" do
      it "returns the number of years as decimal" do
        user.stub(:join_date).and_return(6.months.ago.to_date)
        user.years_at_company.should  == 0.5
      end
    end

    context "no join date" do
      it "returns 0 years" do
        user.stub(:join_date).and_return(nil)
        user.years_at_company.should  == 0.0
      end
    end
  end

  describe "accrual_rate" do
    it "calls Accrual.find_rate" do
      user.stub(:join_date).and_return(6.months.ago.to_date)
      Accrual.should_receive(:find_rate).with(subscriber, "VacationAccrual", 0.5)
      user.accrual_rate("VacationAccrual")
    end
  end
end

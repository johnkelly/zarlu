require 'spec_helper'

describe EmployeesController do
  let(:employee) { users(:test_example_com) }
  let(:manager) { users(:manager_example_com) }
  let(:event) { events(:build_model) }
  let(:subscriber) { subscribers(:trial) }
  let(:invitation) { double("Invitation") }
  before { sign_in(manager) }

  describe '#index' do
    before { get :index }
    it { should respond_with(:success) }
  end

  describe "#new" do
    before { get :new }
    it { should respond_with(:success) }
  end

  describe 'create' do
    before do
      Invitation.should_receive(:new).with(["invite1@example.com, invite2@example.com"], manager).and_return(invitation)
      invitation.should_receive(:mass_send)
      EmployeesController.any_instance.should_receive(:charge_credit_card).with(subscriber)
      post :create, employee: { emails: ["invite1@example.com, invite2@example.com"] }
    end
    it { should redirect_to manager_setup_data_path }
    it { assigns(:subscriber).should == subscriber }
  end

  describe '#update' do
    context "approve" do
      before do
        ApplicationController.any_instance.should_receive(:track_activity!)
        Event.any_instance.should_receive(:approve!).and_return(true)
        patch :update, id: event.to_param, type: "approve"
      end
      it { assigns(:my_employees).should == manager.employees }
      it { assigns(:my_employee_pending_event).should == event }
      it { should redirect_to employees_url }
      it { should set_the_flash[:notice] }
    end

    context "reject" do
      before do
        ApplicationController.any_instance.should_receive(:track_activity!)
        Event.any_instance.should_receive(:reject!).and_return(true)
        patch :update, id: event.to_param, type: "reject"
      end
      it { assigns(:my_employees).should == manager.employees }
      it { assigns(:my_employee_pending_event).should == event }
      it { should redirect_to employees_url }
      it { should set_the_flash[:notice] }
    end
  end

  describe "#show" do
    before { EventDurationService.should_receive(:new) }
    context "display logs" do
      before { get :show, id: employee.to_param }
      it { should respond_with(:success) }
      it { assigns(:display).should == "logs" }
      it { assigns(:subscriber).should == subscriber }
      it { assigns(:employee).should == employee }
      it { assigns(:manager).should == "Manager@example.com" }
      it { assigns(:events).should == employee.events.scheduled.lifo }
    end

    context "display charts" do
      before { get :show, id: manager.to_param, charts: "charts" }
      it { should respond_with(:success) }
      it { assigns(:display).should == "charts" }
      it { assigns(:subscriber).should == subscriber }
      it { assigns(:employee).should == manager }
      it { assigns(:manager).should == "No Manager Assigned" }
      it { assigns(:events).should == manager.events.scheduled.lifo }
    end
  end
end

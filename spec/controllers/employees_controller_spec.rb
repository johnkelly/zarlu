require 'spec_helper'

describe EmployeesController do
  let(:manager) { users(:manager_example_com) }
  let(:event) { events(:build_model) }
  before { sign_in(manager) }

  describe '#index' do
    before { get :index }
    it { should respond_with(:success) }
  end

  describe '#update' do
    context "approve" do
      before do
        ApplicationController.any_instance.should_receive(:track_activity!)
        Event.any_instance.should_receive(:approve!).and_return(true)
        put :update, id: event.to_param, type: "approve"
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
        put :update, id: event.to_param, type: "reject"
      end
      it { assigns(:my_employees).should == manager.employees }
      it { assigns(:my_employee_pending_event).should == event }
      it { should redirect_to employees_url }
      it { should set_the_flash[:notice] }
    end
  end
end

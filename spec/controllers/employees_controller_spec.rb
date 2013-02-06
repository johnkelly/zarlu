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
        Event.any_instance.should_receive(:approve!).and_return(true)
        put :update, id: event.to_param, type: "approve"
      end
      it { should assign_to(:my_employees).with(manager.employees) }
      it { should assign_to(:my_employee_pending_event).with(event) }
      it { should redirect_to employees_url }
      it { should set_the_flash[:notice] }
    end

    context "reject" do
      before do
        Event.any_instance.should_receive(:reject!).and_return(true)
        put :update, id: event.to_param, type: "reject"
      end
      it { should assign_to(:my_employees).with(manager.employees) }
      it { should assign_to(:my_employee_pending_event).with(event) }
      it { should redirect_to employees_url }
      it { should set_the_flash[:notice] }
    end
  end
end

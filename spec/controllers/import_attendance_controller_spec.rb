require 'spec_helper'

describe ImportAttendanceController do
  let(:user) { users(:manager_example_com) }
  let(:subscriber) { subscribers(:trial) }
  let(:csv_url) { "https://www.filepicker.io/zarlu" }
  before { sign_in user }

  describe "#new" do
    before { get :new }
    it { should respond_with(:success) }
    it { assigns(:subscriber).should == subscriber }
    it { assigns(:attendance_csv).should be_new_record }
  end

  describe "#create" do
    context "http" do
      context "success" do
        before do
          AttendanceCsv.any_instance.should_receive(:process_csv)
          post :create, attendance_csv: { csv: csv_url }
        end
        it { should redirect_to manager_setup_complete_path }
        it { assigns(:subscriber).should == subscriber }
        it { assigns(:attendance_csv).should be_a AttendanceCsv }
      end

      context "failure" do
        before { post :create, attendance_csv: { csv: "" }}
        it { should redirect_to manager_setup_data_path }
      end
    end

    context "database" do
      before { AttendanceCsv.any_instance.should_receive(:process_csv) }
      it "creates an attendance csv" do
        -> { post :create, attendance_csv: { csv: csv_url }}.should change(AttendanceCsv, :count).by(1)
      end
    end
  end
end

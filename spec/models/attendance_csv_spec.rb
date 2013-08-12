require 'spec_helper'

describe AttendanceCsv do
  let(:attendance_csv_1) { attendance_csvs(:attendance_csvs_001) }
  let(:attendance_csv_2) { attendance_csvs(:attendance_csvs_002) }
  let(:csv_data) { File.open('spec/files/valid.csv').read }

  describe "attributes" do
    it { should belong_to(:subscriber) }
    it { should validate_presence_of(:subscriber_id) }
    it { should validate_presence_of(:csv) }
  end

  describe "self.process_csv" do
    pending "Sidekiq making this difficult"
  end

  describe "process_csv" do
    before { attendance_csv_1.stub(:csv_data).and_return(csv_data) }

    it "calls import for the row and marks the attendance csv as processed" do
      AttendanceCsvRow.any_instance.should_receive(:import).with(attendance_csv_1.subscriber_id)
      attendance_csv_1.should_receive(:update!).with({ processed: true })
      attendance_csv_1.process_csv
    end
  end
end

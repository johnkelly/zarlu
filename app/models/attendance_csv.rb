require 'csv'

class AttendanceCsv < ActiveRecord::Base
  belongs_to :subscriber, touch: true

  validates_presence_of :subscriber_id, :csv

  def process_csv
    rows = read_csv_file
    valid_rows = rows.select(&:valid?)
    import_data(valid_rows)
    self.update!(processed: true)
  end

  def csv_data
    open(csv).read
  end

  private

  def read_csv_file
    csv_rows = []
    CSV.parse(csv_data, encoding: Encoding::UTF_8, headers: true) do |line|
      csv_rows << AttendanceCsvRow.new(email: line[0], hire_date: line[1], vacation_balance: line[2], sick_balance: line[3],
                                      personal_balance: line[4], unpaid_balance: line[5], other_balance: line[6])
    end
    csv_rows
  end


  def import_data(valid_rows)
    valid_rows.each do |valid_row|
      valid_row.import(subscriber_id)
    end
  end
end

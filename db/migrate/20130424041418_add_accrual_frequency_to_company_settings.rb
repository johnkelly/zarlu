class AddAccrualFrequencyToCompanySettings < ActiveRecord::Migration
  def change
    add_column :company_settings, :accrual_frequency, :integer, default: 0
  end
end

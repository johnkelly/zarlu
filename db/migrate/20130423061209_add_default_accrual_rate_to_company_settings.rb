class AddDefaultAccrualRateToCompanySettings < ActiveRecord::Migration
  def change
    add_column :company_settings, :default_accrual_rate, :decimal, default: 0
  end
end

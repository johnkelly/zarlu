class RemoveDefaultAccrualRateFromCompanySettings < ActiveRecord::Migration
  def change
    remove_column :company_settings, :default_accrual_rate, :decimal
  end
end

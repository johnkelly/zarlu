class AddStartAccrualToCompanySettings < ActiveRecord::Migration
  def change
    add_column :company_settings, :start_accrual, :date
  end
end

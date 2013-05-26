class AddAccrualLimitToCompanySettings < ActiveRecord::Migration
  def change
    add_column :company_settings, :accrual_limit, :decimal
  end
end

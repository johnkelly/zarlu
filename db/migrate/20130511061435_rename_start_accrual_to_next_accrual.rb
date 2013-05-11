class RenameStartAccrualToNextAccrual < ActiveRecord::Migration
  def change
    rename_column :company_settings, :start_accrual, :next_accrual
  end
end

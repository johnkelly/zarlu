class CreateCompanySettings < ActiveRecord::Migration
  def change
    create_table :company_settings do |t|
      t.string :type
      t.integer :subscriber_id
      t.boolean :enabled, default: true, null: false

      t.timestamps
    end
  end
end

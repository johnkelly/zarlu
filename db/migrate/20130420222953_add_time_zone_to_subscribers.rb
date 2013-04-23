class AddTimeZoneToSubscribers < ActiveRecord::Migration
  def change
    add_column :subscribers, :time_zone, :string, default: "Pacific Time (US & Canada)"
  end
end

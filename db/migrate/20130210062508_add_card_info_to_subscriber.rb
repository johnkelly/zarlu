class AddCardInfoToSubscriber < ActiveRecord::Migration
  def change
    add_column :subscribers, :card_last4, :string
    add_column :subscribers, :card_type, :string
  end
end

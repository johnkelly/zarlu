class AddCustomerTokenToSubscriber < ActiveRecord::Migration
  def change
    add_column :subscribers, :customer_token, :string
  end
end

class AddConfirmedAtAndShippedAtToOrders < ActiveRecord::Migration[7.0]
  def change
    add_column :orders, :confirmed_at, :datetime
    add_column :orders, :shipped_at, :datetime
    add_column :orders, :cancel_at, :datetime
  end
end

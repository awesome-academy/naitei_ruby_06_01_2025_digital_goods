class AddCheckedToCart < ActiveRecord::Migration[7.0]
  def change
    add_column :cart_items, :checked, :boolean, default: false
  end
end

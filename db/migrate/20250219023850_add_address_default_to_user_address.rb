class AddAddressDefaultToUserAddress < ActiveRecord::Migration[7.0]
  def change
    add_column :user_addresses, :address_default, :boolean, default: false
  end
end

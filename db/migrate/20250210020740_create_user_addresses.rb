class CreateUserAddresses < ActiveRecord::Migration[7.0]
  def change
    create_table :user_addresses do |t|
      t.string :location
      t.references :user, null: false, foreign_key: true
      t.references :province, null: false, foreign_key: true
      t.references :district, null: false, foreign_key: true
      t.references :ward, null: false, foreign_key: true

      t.timestamps
    end
  end
end

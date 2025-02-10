class CreateOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :orders do |t|
      t.decimal :total_price
      t.decimal :delivery_fee
      t.boolean :payment_status, default: false
      t.integer :status
      t.text :notice, null: true, default: nil
      t.string :reason_cancel, null: true, default: nil
      t.references :user, null: false, foreign_key: true
      t.references :user_address, null: false, foreign_key: true

      t.timestamps
    end
  end
end

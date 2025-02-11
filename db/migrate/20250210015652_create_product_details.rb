class CreateProductDetails < ActiveRecord::Migration[7.0]
  def change
    create_table :product_details do |t|
      t.string :device_condition
      t.string :warranty
      t.string :accessories
      t.string :vat
      t.references :product, null: false, foreign_key: true, unique: true

      t.timestamps
    end
  end
end

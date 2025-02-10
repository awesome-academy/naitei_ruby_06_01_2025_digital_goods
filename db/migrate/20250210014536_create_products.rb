class CreateProducts < ActiveRecord::Migration[7.0]
  def change
    create_table :products do |t|
      t.string :product_title
      t.text :description
      t.decimal :price, precision: 12, scale: 2, default: 0.0
      t.integer :discount
      t.decimal :rating, precision:2, scale:1, default: 0.0
      t.string :color
      t.integer :stock_quantity

      t.timestamps
    end
  end
end

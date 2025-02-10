class CreateProductAttributes < ActiveRecord::Migration[7.0]
  def change
    create_table :product_attributes do |t|
      t.references :product, null: false, foreign_key: true
      t.references :attribute_group, null: false, foreign_key: true
      t.string :value, null: false

      t.timestamps
    end
  end
end

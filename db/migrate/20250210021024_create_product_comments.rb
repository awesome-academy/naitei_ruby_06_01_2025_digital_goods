class CreateProductComments < ActiveRecord::Migration[7.0]
  def change
    create_table :product_comments do |t|
      t.text :content
      t.integer :likes
      t.references :product, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.references :parent_comment, null: true, foreign_key: { to_table: :product_comments }

      t.timestamps
    end
  end
end

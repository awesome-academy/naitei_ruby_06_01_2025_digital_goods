class CreateCategories < ActiveRecord::Migration[7.0]
  def change
    create_table :categories do |t|
      t.string :name, unique: true
      t.string :path, unique: true
      t.integer :level

      t.timestamps
    end
  end
end

class CreateAttributeGroups < ActiveRecord::Migration[7.0]
  def change
    create_table :attribute_groups do |t|
      t.string :attribute_name, null: false, unique: true
      t.string :path, null: false, unique: true
      t.integer :level

      t.timestamps
    end
  end
end

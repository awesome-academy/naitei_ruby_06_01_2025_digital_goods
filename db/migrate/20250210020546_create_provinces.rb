class CreateProvinces < ActiveRecord::Migration[7.0]
  def change
    create_table :provinces do |t|
      t.string :name, unique: true

      t.timestamps
    end
  end
end

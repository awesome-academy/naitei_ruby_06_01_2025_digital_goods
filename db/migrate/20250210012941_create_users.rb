class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.string :user_name, unique: true
      t.string :full_name
      t.string :email, unique: true
      t.string :telephone
      t.string :password_digest
      t.boolean :admin, default: false
      t.integer :status

      t.timestamps
    end
  end
end

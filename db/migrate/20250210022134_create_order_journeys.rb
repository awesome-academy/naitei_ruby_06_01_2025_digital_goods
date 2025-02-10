class CreateOrderJourneys < ActiveRecord::Migration[7.0]
  def change
    create_table :order_journeys do |t|
      t.string :location
      t.references :order, null: false, foreign_key: true
      t.references :province, null: false, foreign_key: true
      t.references :district, null: false, foreign_key: true
      t.references :ward, null: false, foreign_key: true
      t.integer :status

      t.timestamps
    end
  end
end

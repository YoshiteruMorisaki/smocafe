class CreateShops < ActiveRecord::Migration[8.0]
  def change
    create_table :shops do |t|
      t.string :name, null: false
      t.string :area, null: false
      t.string :address, null: false
      t.string :business_hours
      t.string :closed_days
      t.integer :heated_tobacco_status, null: false, default: 0
      t.integer :papper_tobacco_status, null: false, default: 0
      t.boolean :wifi_available, null: false, default: false
      t.boolean :power_available, null: false, default: false
      t.text :description
      t.datetime :last_reported_at
      t.timestamps
    end

    add_index :shops, :area
    add_index :shops, :last_reported_at
  end
end

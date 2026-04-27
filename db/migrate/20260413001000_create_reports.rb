class CreateReports < ActiveRecord::Migration[8.0]
  def change
    create_table :reports do |t|
      t.references :user, null: false, foreign_key: true
      t.references :shop, null: false, foreign_key: true
      t.date :visited_on, null: false
      t.integer :heated_tobacco_status, null: false, default: 0
      t.integer :papper_tobacco_status, null: false, default: 0
      t.text :comment, null: false

      t.timestamps
    end

    add_index :reports, [ :shop_id, :visited_on ]
    add_index :reports, :created_at
  end
end

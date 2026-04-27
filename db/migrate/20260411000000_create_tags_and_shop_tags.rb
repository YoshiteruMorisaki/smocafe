class CreateTagsAndShopTags < ActiveRecord::Migration[8.0]
  def change
    create_table :tags do |t|
      t.string :name, null: false

      t.timestamps
    end

    add_index :tags, :name, unique: true

    create_table :shop_tags do |t|
      t.references :shop, null: false, foreign_key: true
      t.references :tag, null: false, foreign_key: true

      t.timestamps
    end

    add_index :shop_tags, [ :shop_id, :tag_id ], unique: true
  end
end

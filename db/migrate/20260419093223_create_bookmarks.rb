class CreateBookmarks < ActiveRecord::Migration[8.0]
  def change
    create_table :bookmarks do |t|
      t.references :user, null: false, foreign_key: true, type: :bigint
      t.references :shop, null: false, foreign_key: true, type: :bigint

      t.timestamps
    end

    add_index :bookmarks, [:user_id, :shop_id], unique: true
  end
end

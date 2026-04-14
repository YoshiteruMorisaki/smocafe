class FixBookmarksForeignKeyTypes < ActiveRecord::Migration[8.0]
  def up
    remove_foreign_key :bookmarks, :users if foreign_key_exists?(:bookmarks, :users)
    remove_foreign_key :bookmarks, :shops if foreign_key_exists?(:bookmarks, :shops)

    change_column :bookmarks, :user_id, :bigint
    change_column :bookmarks, :shop_id, :bigint

    add_foreign_key :bookmarks, :users
    add_foreign_key :bookmarks, :shops
  end

  def down
    remove_foreign_key :bookmarks, :users if foreign_key_exists?(:bookmarks, :users)
    remove_foreign_key :bookmarks, :shops if foreign_key_exists?(:bookmarks, :shops)

    change_column :bookmarks, :user_id, :integer
    change_column :bookmarks, :shop_id, :integer

    add_foreign_key :bookmarks, :users
    add_foreign_key :bookmarks, :shops
  end
end

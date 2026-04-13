class FixReportsAndShopTagsForeignKeyTypes < ActiveRecord::Migration[8.0]
  def up
    remove_foreign_key :reports, :users if foreign_key_exists?(:reports, :users)
    remove_foreign_key :reports, :shops if foreign_key_exists?(:reports, :shops)
    remove_foreign_key :shop_tags, :shops if foreign_key_exists?(:shop_tags, :shops)
    remove_foreign_key :shop_tags, :tags if foreign_key_exists?(:shop_tags, :tags)

    change_column :reports, :user_id, :bigint
    change_column :reports, :shop_id, :bigint
    change_column :shop_tags, :shop_id, :bigint
    change_column :shop_tags, :tag_id, :bigint

    add_foreign_key :reports, :users
    add_foreign_key :reports, :shops
    add_foreign_key :shop_tags, :shops
    add_foreign_key :shop_tags, :tags
  end

  def down
    remove_foreign_key :reports, :users if foreign_key_exists?(:reports, :users)
    remove_foreign_key :reports, :shops if foreign_key_exists?(:reports, :shops)
    remove_foreign_key :shop_tags, :shops if foreign_key_exists?(:shop_tags, :shops)
    remove_foreign_key :shop_tags, :tags if foreign_key_exists?(:shop_tags, :tags)

    change_column :reports, :user_id, :integer
    change_column :reports, :shop_id, :integer
    change_column :shop_tags, :shop_id, :integer
    change_column :shop_tags, :tag_id, :integer

    add_foreign_key :reports, :users
    add_foreign_key :reports, :shops
    add_foreign_key :shop_tags, :shops
    add_foreign_key :shop_tags, :tags
  end
end

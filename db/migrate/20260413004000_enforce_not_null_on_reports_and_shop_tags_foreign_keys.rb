class EnforceNotNullOnReportsAndShopTagsForeignKeys < ActiveRecord::Migration[8.0]
  def up
    change_column_null :reports, :user_id, false
    change_column_null :reports, :shop_id, false
    change_column_null :shop_tags, :shop_id, false
    change_column_null :shop_tags, :tag_id, false
  end

  def down
    change_column_null :reports, :user_id, true
    change_column_null :reports, :shop_id, true
    change_column_null :shop_tags, :shop_id, true
    change_column_null :shop_tags, :tag_id, true
  end
end

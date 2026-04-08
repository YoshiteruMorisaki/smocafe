class FixSessionsForeignKeyTypes < ActiveRecord::Migration[8.0]
  def up
    remove_foreign_key :sessions, :users if foreign_key_exists?(:sessions, :users)
    remove_foreign_key :sessions, :admins if foreign_key_exists?(:sessions, :admins)

    change_column :sessions, :user_id, :bigint
    change_column :sessions, :admin_id, :bigint

    add_foreign_key :sessions, :users
    add_foreign_key :sessions, :admins
  end

  def down
    remove_foreign_key :sessions, :users if foreign_key_exists?(:sessions, :users)
    remove_foreign_key :sessions, :admins if foreign_key_exists?(:sessions, :admins)

    change_column :sessions, :user_id, :integer
    change_column :sessions, :admin_id, :integer

    add_foreign_key :sessions, :users
    add_foreign_key :sessions, :admins
  end
end

class AddUidAndEmailIndexesToUsers < ActiveRecord::Migration
  def change
    add_index :users, :uid
    add_index :users, :email
  end
end

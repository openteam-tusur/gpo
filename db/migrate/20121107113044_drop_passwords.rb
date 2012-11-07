class DropPasswords < ActiveRecord::Migration
  def up
    drop_table  :passwords
  end

  def down
    create_table "passwords", :force => true do |t|
      t.integer  "user_id"
      t.string   "reset_code"
      t.datetime "expiration_date"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
  end
end

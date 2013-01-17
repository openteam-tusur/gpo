class ChangeTypeOfFileUpdatedAtToDatetimeInOrders < ActiveRecord::Migration
  def up
    change_column :orders, :file_updated_at, :datetime
  end

  def down
    change_column :orders, :file_updated_at, :date
  end
end

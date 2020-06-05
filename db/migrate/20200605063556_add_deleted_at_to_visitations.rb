class AddDeletedAtToVisitations < ActiveRecord::Migration
  def change
    add_column :visitations, :deleted_at, :datetime
    add_index :visitations, :deleted_at
  end
end

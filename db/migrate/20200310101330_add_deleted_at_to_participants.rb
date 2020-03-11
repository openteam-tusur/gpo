class AddDeletedAtToParticipants < ActiveRecord::Migration
  def change
    add_column :participants, :deleted_at, :datetime
    add_index :participants, :deleted_at
  end
end

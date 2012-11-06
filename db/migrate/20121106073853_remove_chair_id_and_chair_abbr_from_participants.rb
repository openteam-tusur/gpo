class RemoveChairIdAndChairAbbrFromParticipants < ActiveRecord::Migration
  def up
    remove_column :participants, :chair_id
    remove_column :participants, :chair_abbr
  end

  def down
    add_column :participants, :chair_id,    :integer
    add_column :participants, :chair_abbr,  :string
  end
end

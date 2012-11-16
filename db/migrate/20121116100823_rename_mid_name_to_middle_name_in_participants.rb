class RenameMidNameToMiddleNameInParticipants < ActiveRecord::Migration
  def change
    rename_column :participants, :mid_name, :middle_name
  end
end

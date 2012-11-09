class AddUndergraduateToParticipants < ActiveRecord::Migration
  def change
    add_column :participants, :undergraduate, :boolean
  end
end

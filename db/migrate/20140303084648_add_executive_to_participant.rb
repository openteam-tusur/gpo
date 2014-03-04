class AddExecutiveToParticipant < ActiveRecord::Migration
  def change
    add_column :participants, :executive, :boolean, :default => false
  end
end

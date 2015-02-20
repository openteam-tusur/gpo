class AddTypeToParticipant < ActiveRecord::Migration
  def change
    add_column :participants, :type, :string
    add_column :participants, :university, :string
  end
end

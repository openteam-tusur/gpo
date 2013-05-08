class AddSubfacultyAndFacultyToParticipant < ActiveRecord::Migration
  def change
    add_column :participants, :subfaculty, :string
    add_column :participants, :faculty, :string
  end
end

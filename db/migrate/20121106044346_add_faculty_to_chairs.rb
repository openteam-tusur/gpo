class AddFacultyToChairs < ActiveRecord::Migration
  def change
    add_column :chairs, :faculty, :string
  end
end

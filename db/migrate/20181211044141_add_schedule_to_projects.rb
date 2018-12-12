class AddScheduleToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :auditorium, :string
    add_column :projects, :class_time, :string, :default => "Четверг с 8.50 до 14.50"
  end
end

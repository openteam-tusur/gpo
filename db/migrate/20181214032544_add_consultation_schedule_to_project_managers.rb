class AddConsultationScheduleToProjectManagers < ActiveRecord::Migration
  def change
    add_column :project_managers, :auditorium, :string
    add_column :project_managers, :consultation_time, :string
  end
end

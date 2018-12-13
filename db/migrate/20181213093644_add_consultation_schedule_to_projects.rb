class AddConsultationScheduleToProjects < ActiveRecord::Migration
  def change
    add_column :projects, :consultation_auditorium, :string
    add_column :projects, :consultation_time, :string
  end
end

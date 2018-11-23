class CreateSchedules < ActiveRecord::Migration
  def change
    create_table :schedules do |t|
      t.references :chair, index: true
      t.string :schedule_type

      t.timestamps
    end
  end
end

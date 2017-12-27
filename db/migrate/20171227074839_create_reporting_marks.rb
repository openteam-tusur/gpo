class CreateReportingMarks < ActiveRecord::Migration
  def change
    create_table :reporting_marks do |t|
      t.string :fullname
      t.string :group
      t.integer :course
      t.string :faculty
      t.string :subfaculty
      t.integer :contingent_id
      t.string :mark

      t.timestamps
    end
    add_reference :reporting_marks, :stage, index: true
  end
end

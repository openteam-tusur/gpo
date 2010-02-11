class CreateIssues < ActiveRecord::Migration
  def self.up
    create_table :issues do |t|
      t.string :name
      t.text :description
      t.date :planned_closing_at
      t.integer :planned_grade
      t.date :closed_at
      t.integer :grade
      t.text :results
      t.integer :participant_id

      t.timestamps
    end
  end

  def self.down
    drop_table :issues
  end
end

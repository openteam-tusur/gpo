class CreateReportingStages < ActiveRecord::Migration
  def change
    create_table :reporting_stages do |t|
      t.text :title
      t.date :start
      t.date :finish

      t.timestamps
    end
  end
end

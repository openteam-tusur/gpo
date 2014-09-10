class CreateStatisticsSnapshots < ActiveRecord::Migration
  def change
    create_table :statistics_snapshots do |t|
      t.text :data

      t.timestamps
    end
  end
end

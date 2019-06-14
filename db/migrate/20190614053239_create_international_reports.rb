class CreateInternationalReports < ActiveRecord::Migration
  def change
    create_table :international_reports do |t|
      t.text :description
      t.references :participant, index: true
      t.references :stage, index: true

      t.timestamps
    end
  end
end

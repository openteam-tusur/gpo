class CreateCertificates < ActiveRecord::Migration
  def change
    create_table :certificates do |t|
      t.references :participant, index: true
      t.string :user_id
      t.text :project_result
      t.text :project_reason
      t.string :state

      t.timestamps
    end
  end
end

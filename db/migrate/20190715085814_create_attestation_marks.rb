class CreateAttestationMarks < ActiveRecord::Migration
  def change
    create_table :attestation_marks do |t|
      t.integer :mark
      t.references :participant, index: true
      t.references :stage, index: true

      t.timestamps
    end
  end
end

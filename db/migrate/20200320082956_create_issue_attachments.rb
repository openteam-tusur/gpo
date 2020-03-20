class CreateIssueAttachments < ActiveRecord::Migration
  def change
    create_table :issue_attachments do |t|
      t.string :title
      t.attachment :document
      t.references :issue, index: true

      t.timestamps
    end
  end
end

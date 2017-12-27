class AddAttachmentsToStage < ActiveRecord::Migration
  def up
    add_attachment :stages, :file_report
    add_attachment :stages, :file_review
  end

  def down
    remove_attachment :stages, :file_report
    remove_attachment :stages, :file_review
  end
end

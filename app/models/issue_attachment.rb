class IssueAttachment < ActiveRecord::Base
  attr_accessible :issue_id,
                  :title,
                  :document
  belongs_to :issue
  validates_presence_of :title, :document_file_name
  has_attached_file :document, {
    path: 'system/:class/:attachment/:id/:filename',
    url: '/system/:class/:attachment/:id/:filename'
  }

  def project
    self.issue.project
  end
end

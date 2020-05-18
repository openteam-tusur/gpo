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
  before_post_process :normalize_document_name

  def project
    self.issue.project
  end

  private

  def normalize_document_name
    ext = File.extname document_file_name

    name = File.basename document_file_name, ext
    name = Russian.transliterate(name).downcase.parameterize.underscore.truncate(200)
    self.document_file_name = %(#{name}#{ext})
  end
end

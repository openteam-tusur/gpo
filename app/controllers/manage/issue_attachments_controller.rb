class Manage::IssueAttachmentsController < Manage::InheritedResourcesController
  before_filter :normalize_attachment_params, only: [:create, :update]

  def new
  end

  def create
    @issue = Issue.find(params[:issue_id])
    @issue_attachment = @issue.issue_attachments.build(params[:issue_attachment])
    if @issue_attachment.save
      redirect_to manage_chair_project_issues_path
    else
      render 'new'
    end
  end

  def update
    if @issue_attachment.update(params[:issue_attachment])
      redirect_to manage_chair_project_issues_path
    else
      render 'edit'
    end
  end

  def destroy
    @issue_attachment.destroy

    redirect_to manage_chair_project_issues_path
  end

  private
  def normalize_attachment_params
    ia_filename = params[:issue_attachment][:document].original_filename
    ext = File.extname ia_filename
    name = File.basename ia_filename, ext
    name = Russian.transliterate(ia_filename).downcase.parameterize.underscore.truncate(200)
    params[:issue_attachment][:document].original_filename = name+ext
  end
end

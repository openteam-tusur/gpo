class Manage::IssueAttachmentsController < Manage::InheritedResourcesController

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
end

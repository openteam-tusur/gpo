# encoding: utf-8

class Manage::ReportingStagesController < Manage::InheritedResourcesController
  actions :all

  def show
    show! do
      @statistics = @reporting_stage.stages.includes(:project, :chair).group_by { |stage|
        stage.project.chair
      }.sort_by { |chair, _|
        chair.title
      }.to_h
    end
  end
end


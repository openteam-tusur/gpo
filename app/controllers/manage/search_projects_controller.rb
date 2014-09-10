# encoding: utf-8

class Manage::SearchProjectsController < Manage::ApplicationController
  include SendReport

  def index
    @chairs = Chair.all
    @themes = Theme.all

    @search_results = if params[:search].present?
                        search = Project.search {
                          keywords params[:q] do
                            highlight :title
                          end
                          if params[:chair].present?
                            with :chair, params[:chair]
                          end
                          if params[:theme].present?
                            with :theme, params[:theme]
                          end
                          if params[:active].present?
                            with :state, 'active'
                          end
                          if params[:interdisciplinary].present?
                            with :interdisciplinary, params[:interdisciplinary]
                          end
                          if params[:category].present?
                            with :category, params[:category]
                          end
                          if params[:sbi_resident].present?
                            with :sbi_resident, params[:sbi_resident]
                          end
                        }

                        search.each_hit_with_result do |hit, project|
                          project[:title] = hit.highlights(:title).first.format do |word|
                            "<span class='search_highlight'>#{word}</span>"
                          end if hit.highlights(:title).any?
                        end

                        search.results
                      else
                        []
                      end

    respond_to do |format|
      format.html { render :action => :index }
      format.xls{
        report = SearchProjectsReport.new(@search_results)

        report.render_to_file do |file|
          send_report file, :xls, "projects_list.xls"
        end
      }
    end
  end
end

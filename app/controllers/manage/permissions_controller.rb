# encoding: utf-8

class Manage::PermissionsController < Manage::InheritedResourcesController

  load_and_authorize_resource

  actions :new, :create, :destroy

  has_scope :page, :default => 1

  def index
    @permissions = if params[:search].present?
                      search = Permission.search {
                        fulltext params[:q]
                        paginate page: params[:page], per_page: 20
                      }
                      @found_count = search.total
                      search.results
                    else
                      @found_count = Permission.count
                      Permission.page(params[:page])
                    end
  end

  def destroy
    destroy! { redirect_to :back and return }
  end

end

# encoding: utf-8

class Manage::ManagersController < Manage::ApplicationController
  inherit_resources

  actions :all, except: :show

  belongs_to :chair, :project

  custom_actions resource: [:approve, :cancel]

  layout 'project'

  def index
    index! {
      @managers.sort!{ |a,b| a.user.last_name <=> b.user.last_name }
    }
  end

  def approve
    approve! {
      awaiting_approval = @manager.awaiting_approval?
      if @manager.approve
        if awaiting_approval
          flash[:notice] = "Назначение руководителя проекта подтверждено"
        else
          flash[:notice] = "Удаление руководителя проекта подтверждено"
        end
      end

      redirect_to collection_url and return
    }
  end

  def cancel
    cancel! {
      awaiting_approval = @manager.awaiting_approval?
      if @manager.cancel
        if awaiting_approval
          flash[:notice] = "Назначение руководителя отменено"
        else
          flash[:notice] = "Удаление руководителя проекта отменено"
        end
      end

      redirect_to collection_url and return
    }
  end

  def destroy
    approve! {
      if @manager.remove
        flash[:notice] = "Руководитель помечен на удаление"
      end

      redirect_to collection_url and return
    }
  end
end

module ExecutiveRedirect
  def self.included(klass)
    klass.class_eval do
      if klass == Manage::ChairsController
        before_filter :redirect_executive, :only => [:show, :index], :if => -> { current_user.executive_participant? }
      else
        before_filter :redirect_executive, :only => :index, :if => -> { current_user.executive_participant? }
      end

      define_method :redirect_executive do
        redirect_to [:manage, current_user.project.chair, current_user.project] and return
      end
    end
  end
end

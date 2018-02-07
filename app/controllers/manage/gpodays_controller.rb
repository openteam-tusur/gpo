# encoding: utf-8

class Manage::GpodaysController < Manage::InheritedResourcesController
  actions :all, except: :show

  has_scope :page, default: 1

  def new_interval
    @gpoday = Gpoday.new
  end

  def create_from_interval
    ap params[:gpoday]
    from = Date.parse(params[:gpoday][:from])
    to = Date.parse(params[:gpoday][:to])
    if from >= to
      @gpoday = Gpoday.new(from: from, to: to)
      @gpoday.errors.add(:from, 'Начальная дата не может быть больше и равна конечной')
      render :new_interval and return
    end

    thursdays = (from..to).group_by(&:wday)[4]
    thursdays.each do |thursday|
      Gpoday.create(date: thursday)
    end

    redirect_to collection_path
  end
end


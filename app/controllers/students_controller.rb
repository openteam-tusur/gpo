# encoding: utf-8

class StudentsController < ApplicationController

  def index
    query = Hash.new
    query[:last_name] = params[:last_name].strip unless params[:last_name].blank?
    query[:edu_group] = params[:edu_group].strip unless params[:edu_group].blank?
    query.delete_if {|key, value| value.blank?}
    @students = Student.find(:all, :params => query) unless query.empty?
    if query.empty?
      @students = []
      flash[:error] = "Не указаны параметры поиска"
    end
  end

  def problematic
    @participants = Participant.problematic
  end
end

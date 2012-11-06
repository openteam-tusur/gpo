# encoding: utf-8

class ChairsController < ApplicationController

  layout 'public'

  def index
    @chairs = Chair.all.group_by(&:faculty)
  end

end

# encoding: utf-8

class ChairsController < ApplicationController

  def index
    @chairs = Chair.all.group_by(&:faculty)
  end

end

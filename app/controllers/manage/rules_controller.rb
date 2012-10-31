# encoding: utf-8

class Manage::RulesController < Manage::ApplicationController
  inherit_resources
  actions :all, except: :show

end

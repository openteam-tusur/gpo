class AttachmentsController < ApplicationController
  def show
    path = Rails.root.join('system', params[:path])
    format = params[:format]
    klass = params[:path].split('/').first.classify.constantize
    id = params[:path].split('/')[-2]
    resource = klass.find(id).inspect
    authorize! :show, resource

    path = %(#{path}.#{format})
    raise ActionController::RoutingError.new('Not Found') unless File.exist?(path)

    send_file path, disposition: 'inline'
  end
end

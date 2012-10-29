# encoding: utf-8
require 'documatic'

class ReportPrinter
  
  def self.render_to_file(report, &block)
    odt_file = Tempfile.new('report_tempfile')
    options = Ruport::Controller::Options.new(:template_file => self.template(report.id),
      :output_file   => odt_file.path )
    Documatic::OpenDocumentText::Template.process_template(:options => options, :data => report.model)
    if block_given?
      block.call(odt_file)
    end
    odt_file.close
  end
    
  protected
  def self.template(report)
    "#{RAILS_ROOT}/lib/templates/reports/#{report}.odt"
  end
end

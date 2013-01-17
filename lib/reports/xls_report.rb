# encoding: utf-8

require 'zip/zip'
require "rexml/document"

class XlsReport
  def semestr
    (1..6).collect.include?(Date.today.month) ? "весеннем" : "осеннем"
  end

  def edu_years
    Date.today.month < 9 ? "#{Date.today.year-1}/#{Date.today.year}" : "#{Date.today.year}/#{Date.today.year+1}"
  end

  def c_year
    Date.today.year.to_s
  end

  # TODO: merge with Order#generate_odt
  def render_to_file(report_basename, &block)
    Rails.logger.info("generate #{report_basename}.odt")
    template = Zip::ZipFile.open("#{Rails.root}/lib/templates/reports/#{report_basename}.ods")

    Dir.mktmpdir do |dir|
      report_filepath = "#{dir}/#{report_basename}.ods"
      Zip::ZipOutputStream.open(report_filepath) do |zip_entry|
        template.each do |entry|
          zip_entry.put_next_entry entry.name
          if entry.name == 'content.xml'
            start = Time.now
            zip_entry.write process_xml_template(template.read(entry.name).force_encoding('utf-8'))
            time = (Time.now - start) / 1000.0
            Rails.logger.debug("[#{report_basename}.ods]: generated #{entry.name} in #{time.round(1)}ms")
          else
            Rails.logger.debug("[#{report_basename}.ods]: copy #{entry.name}")
            zip_entry.print template.read(entry.name)
          end
        end
      end
      yield File.new(report_filepath)
    end
  end

  def process_xml_template(xml)
    xml
  end

end


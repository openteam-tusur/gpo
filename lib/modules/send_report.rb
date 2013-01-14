module SendReport
  include ConvertedReport

  def send_report(file, format, filename = nil)
    converted_report(file, format) do |converted_file|
      send_data File.open(converted_file) {|f| f.read},
                :filename => filename || File.basename(converted_file.path),
                :type => Paperclip::ContentTypeDetector.new(converted_file.path).detect
    end
  end
end

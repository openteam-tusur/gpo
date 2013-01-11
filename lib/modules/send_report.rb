module SendReport
  include ConvertedReport
  # TODO: check this
  def send_report(file, format, filename = nil)
    filename ||= File.basename(file.path)
    converted_report(file, format) do |file|
      send_file file
    end
  end
end

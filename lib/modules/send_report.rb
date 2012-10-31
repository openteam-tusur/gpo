module SendReport
  def send_report(file, format, filename = nil)
    file = File.new(file) if file.is_a?(String)
    curl = Curl::Easy.new("http://docon.openteam.ru/")
    curl.multipart_form_post = true
    content_type = ""
    curl.on_header do |header|
      if match = header.match(/Content-Type: ([^[:space:]]+)/)
        content_type = match[1]
      end
      header.length
    end
    curl.http_post(Curl::PostField.file('file', file.path), Curl::PostField.content('format', format.to_s))
    # FIXME: remove this stuff
    filename ||= File.basename(file.path)
    send_data curl.body_str, :filename => File.basename(filename, '.*') + ".#{format}",
    :type => content_type
  end
end

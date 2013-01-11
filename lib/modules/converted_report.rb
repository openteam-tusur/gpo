module ConvertedReport
  def converted_report(file, format, &block)
    file = File.new(file) if file.is_a?(String)

    curl = Curl::Easy.new(Settings['converter.url'])
    curl.multipart_form_post = true

    converted = false
    curl.on_success do |easy|
      converted = true
    end

    3.times do
      curl.http_post(Curl::PostField.file('file', file.path), Curl::PostField.content('format', format.to_s))
      if converted
        Dir.mktmpdir do |dir|
          File.open("#{dir}/#{File.basename(file.path, '.*')}.#{format}", 'wb') do |converted_file|
            converted_file.write(curl.body_str)
            converted_file.rewind
            yield converted_file
          end
        end
        return
      end
    end

    throw "Cann't convert #{File.basename(file.path)} to #{format} format"
  end


end

module ConvertedReport
  def converted_report(file, format, &block)
    file = File.new(file) if file.is_a?(String)

    curl = Curl::Easy.new(Settings['converter.url'])
    curl.multipart_form_post = true

    converted = false
    curl.on_success do |easy|
      converted = true if curl.body_str.present?
    end

    file_to_format = "#{file.path} to #{format} format"
    3.times do |i|
      attempt = "[attempt #{i+1}]"
      Rails.logger.info("#{attempt} converting #{file_to_format}")
      curl.http_post(Curl::PostField.file('file', file.path), Curl::PostField.content('format', format.to_s))
      if converted
        Rails.logger.info("#{attempt} converting #{file_to_format} successfully completed")
        Dir.mktmpdir do |dir|
          File.open("#{dir}/#{File.basename(file.path, '.*')}.#{format}", 'wb') do |converted_file|
            converted_file.write(curl.body_str)
            converted_file.rewind
            Rails.logger.info("#{attempt} converted file #{converted_file.path} stored")
            yield converted_file
          end
        end
        return
      else
        if curl.body_str.empty?
          reason = "[reason: empty response]"
        else
          splitter = '-' * 20
          reason = "response:\n#{splitter}\n#{curl.body_str}\n#{splitter}"
        end
        Rails.logger.warn("#{attempt} converting #{file_to_format} failed #{reason}")
      end
    end
    throw "Cann't convert #{File.basename(file.path)} to #{format} format"
  end


end

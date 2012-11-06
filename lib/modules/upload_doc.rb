module UploadDoc
  include SendReport
  include GenerateOdt

  def upload_file(generated_odt=nil)
    file_uploaded = false
    mkdir(file_vfs_path)
    curl = Curl::Easy.new("#{storage_api_url}?cmd=upload&target=#{encode_path_to_hash(file_vfs_path)}") do |curl|
      curl.headers['Accept'] = 'application/json'
      curl.multipart_form_post = true
      curl.on_success { file_uploaded = true  }
    end
    docfile = File.open("/tmp/order_#{self.id}.doc", 'wb')

    generated_odt ||= generate_odt(self).path
    report = {}
    while report[:content_type] != 'application/msword'
      report = convert_report(generated_odt, :doc)
    end

    docfile.write(report[:body])
    docfile.close
    curl.http_post(Curl::PostField.file('upload[]', docfile.path)) while !file_uploaded
    File.unlink docfile.path
    File.unlink
    self.update_attribute :vfs_path, JSON.parse(curl.body_str)['added'].first['url']
  end

  def remove_file
    Curl.get("#{storage_api_url}?cmd=rm&targets[]=#{file_vfs_path_hash}")
    self.update_attribute :vfs_path, nil
  end

  def mkdir(path)
    Curl.get("#{storage_api_url}/#{path}?cmd=ls&target=r1")
  end

  private
    def storage_api_url
      "#{Settings['storage.url']}/api/el_finder/v2"
    end

    def file_vfs_path
      "/gpo/orders/#{self.created_at.to_date}"
    end

    def file_vfs_path_hash
      encode_path_to_hash("#{file_vfs_path}/order_#{self.id}.doc")
    end

    def encode_path_to_hash(path)
      "r1_#{Base64.urlsafe_encode64(path).strip.tr('=', '')}"
    end
end

require 'zip/zip'

module GenerateOdt
  def generate_odt(order)
    zip = Zip::ZipFile.open("#{Rails.root}/lib/templates/reports/#{order.class.name.underscore}.odt")
    @order = order
    @chair = order.projects.first.chair
    erb = ERB.new File.read(Rails.root.join("lib", "templates", "reports", order.class.name.underscore, "content.xml"))

    generated_odt = Tempfile.new("my-temp-filename-#{Time.now}")

    Zip::ZipOutputStream.open(generated_odt.path) do |z|
      zip.each do |entry|
        z.put_next_entry entry.name
        if entry.name == 'content.xml'
          z.write erb.result(binding)
        else
          z.print zip.read(entry.name)
        end
      end
    end

    generated_odt
  end
end

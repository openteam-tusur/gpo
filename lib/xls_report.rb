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

  def render_to_file(template, &block)
    tmp_dir = %x[/bin/mktemp -d].strip + "/"
    file_name = 'report.ods'
    FileUtils.mkpath("#{tmp_dir}1/")
    system("unzip #{RAILS_ROOT}/lib/templates/reports/#{template}.ods -d #{tmp_dir}1/ > /dev/null")
    xml = File.read("#{tmp_dir}1/content.xml")

    file_content = File.new("#{tmp_dir}1/content.xml", "w+")
    file_content.write(process_xml_template(xml))
    file_content.close
    system("cd #{tmp_dir}1/; zip -r ../#{file_name} .  > /dev/null")
    if block_given?
      block.call(File.new("#{tmp_dir}#{file_name}"))
    end
    FileUtils.remove_entry(tmp_dir, true)
  end

  def process_xml_template(xml)
    xml
  end

end


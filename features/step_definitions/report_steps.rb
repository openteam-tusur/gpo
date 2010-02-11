When /^я на списке отчетов ГПО по университету$/ do
  visit reports_url
end

Then /^мне (запрещ\w+|разреш\w+) просмотр списка общеуниверситетских отчетов$/ do |permission|
  can_visit reports_url, permission, "вижу список общеуниверситетских отчетов"
end

Then /^мне (запрещ\w+|разреш\w+) просмотр отчета "(.*)"$/ do |permission, report_title|
  report_key = ""
  Report::REPORTS[:university].each do |report|
    if report[:title].eql?(report_title)
      report_key = report[:id].to_s
      break
    end
  end
  raise "Нет такого отчета" if report_key.empty?
  can_visit report_url(report_key, :format => :odt), permission, "могу просмотреть отчет #{report_title}"
end

Then /^мне (\w+) просмотр графика работы групп кафедры (\w+)$/ do |permission, abbr|
  chair = find_or_create_chair(abbr)
  can_visit report_url(:chair_schedule_group, :format => :xls, :chair => chair.id), permission, "могу посмотреть отчет"
end

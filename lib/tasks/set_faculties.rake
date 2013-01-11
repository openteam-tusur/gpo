# encoding: utf-8

desc "Update faculty for chair unless exist"
task :set_faculties => :environment do
  def update_chair(abbr, faculty_name)
    chair = Chair.find_by_abbr(abbr)
    puts "Not found abbr: #{abbr}" unless chair.present?
    puts "Not need update: #{chair.id} - #{chair.title} (#{chair.abbr})" if chair.present? && chair.faculty.present?
    puts "Update: #{chair.id} - #{chair.title} (#{chair.abbr})" if chair.present? && chair.faculty.nil?
    chair.update_attribute :faculty, faculty_name if chair.present? && chair.faculty.nil?
  end

  faculty_name = "Радиотехнический факультет (РТФ)"
  puts "=== #{faculty_name} ==="
  %w(РЗИ РТС СВЧиКР ТУ ТОР СРС).each do |abbr|
    update_chair abbr, faculty_name
  end

  faculty_name = "Радиоконструкторский факультет (РКФ)"
  puts "=== #{faculty_name} ==="
  %w(КИПР КУДР РЭТЭМ).each do |abbr|
    update_chair abbr, faculty_name
  end

  faculty_name = "Факультет вычислительных систем (ФВС)"
  puts "=== #{faculty_name} ==="
  %w(КСУП КИБЭВС ЭСАУ М\ и\ Г).each do |abbr|
    update_chair abbr, faculty_name
  end

  faculty_name = "Факультет систем управления (ФСУ)"
  puts "=== #{faculty_name} ==="
  %w(АОИ АСУ).each do |abbr|
    update_chair abbr, faculty_name
  end

  faculty_name = "Факультет электронной техники (ФЭТ)"
  puts "=== #{faculty_name} ==="
  %w(ПрЭ ФЭ ЭП).each do |abbr|
    update_chair abbr, faculty_name
  end

  faculty_name = "Факультет инновационных технологий (ФИТ)"
  puts "=== #{faculty_name} ==="
  %w(ОКЮ УИ\ ИИ ЭС).each do |abbr|
    update_chair abbr, faculty_name
  end

  faculty_name = "Экономический факультет (ЭФ)"
  puts "=== #{faculty_name} ==="
  %w(Экономики ЭМИС).each do |abbr|
    update_chair abbr, faculty_name
  end

  faculty_name = "Гуманитарный факультет (ГФ)"
  puts "=== #{faculty_name} ==="
  %w(ИСР ФС ИЯ СПС ФВиС).each do |abbr|
    update_chair abbr, faculty_name
  end

  faculty_name = "Факультет моделирования систем (ФМС)"
  puts "=== #{faculty_name} ==="
  %w(СА МОТЦ ЦНТТС ВКИЭМ).each do |abbr|
    update_chair abbr, faculty_name
  end
end

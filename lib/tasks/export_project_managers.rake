require 'progress_bar'
require 'spreadsheet'

desc 'Экспорт руководителей проектов ГПО в xls файл'
task export_project_managers: :environment do
  people = ProjectManager.active.includes(:person)
    .order('people.last_name, people.first_name, people.middle_name')
    .where.not(people: { email: '' })
    .map(&:person).uniq
  bar = ProgressBar.new(people.count)
  book = Spreadsheet::Workbook.new
  sheet = book.create_worksheet name: %[Руководители проектов ГПО на #{I18n.l Date.today} с указанными email]
  sheet.row(0).concat %w[ФИО Email]
  people.each_with_index do |person, index|
    row = sheet.row(index + 1)
    row.insert 0, person.fullname
    row.insert 1, person.email
    bar.increment!
  end
  path = Rails.root.join('public', %[project-managers-#{Date.today}.xls])

  (0...sheet.column_count).each do |col|
    high = 1
    row = 0
    sheet.column(col).each do |cell|
      w = cell == nil || cell == '' ? 1 : cell.to_s.strip.split('').count + 1
      ratio = sheet.row(row).format(col).font.size / 10
      w = (w*ratio).round
      high = w if w > high
      row += 1
    end
    sheet.column(col).width = high
  end
  (0...sheet.row_count).each do |row|
    high = 1
    col = 0
    sheet.row(row).each do |cell|
      w = sheet.row(row).format(col).font.size + 4
      high = w if w > high
      col += 1
    end
    sheet.row(row).height = high
  end

  book.write path

  p %[Data writed to #{path}]
end

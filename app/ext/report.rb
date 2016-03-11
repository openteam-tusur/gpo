# encoding: utf-8
class Report
  attr_accessor :model, :id

  def initialize (id, chair = nil, project = nil)
    @id = id
    case @id
    when "all_projects"
      @model = build_data_all_projects
    when "project_tz"
      @model = project
    when "chair_statement_checkup"
      @model = chair
    else raise "Нет такого типа отчета"
    end
    raise "Ошибка инициализации отчета" if model.nil?
  end


  REPORTS = {
    :university => [
      {:id => :university_participants,
        :title => "Списки студентов",
        :description => "Списки студентов участвующих в ГПО, в формате MS Excel",
        :type => "xls"},
      {:id => :university_projects,
        :title => "Список проектов",
        :description => "Сведения о проектах в формате MS Excel",
        :type => "xls"}
    ],
    :chair => [
      {:id => :chair_schedule_group,
        :title => "График работы групп",
        :description => "Скачать бланк графика работы групп ГПО в формате MS Excel",
        :type => "xls"},
      {:id => :chair_schedule_project_managers,
        :title => "График работы руководителей",
        :description => "Скачать бланк графика работы руководителей групп ГПО в формате MS Excel",
        :type => "xls"},
      {:id => :chair_projects_list,
        :title => "Список групп ГПО",
        :description => "Скачать отчет по 'Список групп ГПО форме №22' в формате MS Excel",
        :type => "xls"},
      {:id => :chair_projects_stat,
        :title => "Перечень проектов ГПО",
        :description => "Скачать отчет 'Перечень проектов ГПО' в формате MS Excel",
        :type => "xls"},
      {:id => :chair_project_managers_list,
        :title => "Список руководителей",
        :description => "Скачать отчет 'Список руководителей групп ГПО' в формате MS Excel",
        :type => "xls"},
      {:id => :chair_attestation,
       :title => "Журнал аттестации",
       :description => "Скачать бланк журнала аттестации участников ГПО в формате MS Excel",
       :type => "xls"
      },
      {:id => :chair_statement_checkup,
        :title => "Акт проверки",
        :description => "Скачать шаблон акта комплексной проверки",
        :type => "doc"}
    ],
    :project => [
      {:id => :project_tz,
        :title => "Техническое задание",
        :description => "Скачать предзаполненное техническое задание по проекту",
        :type => "doc"}
    ]
  }

  def build_data_all_projects
    data = Hash.new
    data[:date_time] = I18n.localize(Time.now, :format => :long)
    data[:chairs] = Chair.find(:all, :order => 'abbr')
    return data
  end

end


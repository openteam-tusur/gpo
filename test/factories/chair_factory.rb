Factory.sequence :abbr do |n|
  "КАФ#{n}"
end

Factory.define :chair do |chair|
  chair.abbr { Factory.next :abbr }
  chair.title 'Кафедра Чего Тотам'
  chair.chief 'Иванов Иван Петрович'
end

Factory.define :aoi_chair do |chair|
  chair.abbr "АОИ"
  chair.title 'Автоматизации Обработки Информации'
  chair.chief 'Ехлаков Юрий Поликарпович'
end

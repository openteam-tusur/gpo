Factory.define :student, :default_strategy => :stub do |student|
  student.first_name { Factory.next(:first_name) }
  student.mid_name { Factory.next(:mid_name) }
  student.last_name { Factory.next(:last_name) }
  student.edu_group '406'
  student.course '3'
  student.chair_abbr 'АОИ'
end

Factory.sequence :first_name do |n|
  "first_name_#{n}"
end

Factory.sequence :mid_name do |n|
  "mid_name_#{n}"
end

Factory.sequence :last_name do |n|
  "last_name_#{n}"
end

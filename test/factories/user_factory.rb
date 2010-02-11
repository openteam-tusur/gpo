Factory.sequence :email do |n|
  "somemail#{n}@email.com"
end

Factory.sequence :name do |n|
  "name_#{n}"
end

Factory.sequence :login do |n|
  "login_#{n}"
end

Factory.define :user do |u|
  u.first_name { Factory.next(:name) }
  u.mid_name { Factory.next(:name) }
  u.last_name { Factory.next(:name) }
  u.login { Factory.next(:login) }
  u.email { Factory.next(:email) }
  u.post 'прачка'
  u.float '206 мк'
  u.phone '701-557, внутренний 1113'
  u.password '123123'
  u.password_confirmation '123123'
end

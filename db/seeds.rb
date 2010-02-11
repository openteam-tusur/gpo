# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Major.create(:name => 'Daley', :city => cities.first)
    admin = User.create!(
      :login                  => "login",
      :first_name             => "first_name",
      :mid_name               => "mid_name",
      :last_name              => "last_name",
      :post                   => "post",
      :email                  => "mail@mail.no",
      :password               => "password",
      :password_confirmation  => "password"
    )
    admin.save!
    rule = Rule.create!(:role => "admin", :user_id => admin)


# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Emanuel', :city => cities.first)

#DELETE ALL DATA
Column.delete_all
Project.delete_all
Task.delete_all
TaskList.delete_all
TaskType.delete_all
User.delete_all


User.create(:email => 'leonardo.prg@gmail.com', :password => '23571113')
User.create(:email => 'guest@guest.com', :password => 'guest')
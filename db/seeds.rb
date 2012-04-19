# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Emanuel', :city => cities.first)

User.create(:mail => "vova4kin@list.ru", :pass => "111111", :role_id => 2)

TopCategory.create(:name => "DESIGNER", :sorting => 6)
TopCategory.create(:name => "WOMEN", :sorting => 5)
TopCategory.create(:name => "MEN", :sorting => 4)
TopCategory.create(:name => "TEENS", :sorting => 3)
TopCategory.create(:name => "HOME", :sorting => 2)
TopCategory.create(:name => "GADGETS", :sorting => 1)

Color.create(:name => "White", :html_val => "#ffffff")
Color.create(:name => "Black", :html_val => "#000000")

Size.create(:name => "1")
Size.create(:name => "2")
Size.create(:name => "3")
Size.create(:name => "4")
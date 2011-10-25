# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)
bet_categories = BetCategory.create([{ :name => 'Other' }, { :name => 'Politics' }, { :name => 'Sports' }, { :name => 'Social' }, { :name => 'Technology' }])
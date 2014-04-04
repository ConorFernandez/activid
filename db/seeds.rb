# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

VideoLength.create! name: '1:30-2 Minutes', cost: 95.0, enabled: true
VideoLength.create! name: '2-3 Minutes', cost: 145.0, enabled: true
VideoLength.create! name: '3-4 Minutes', cost: 185.0, enabled: true
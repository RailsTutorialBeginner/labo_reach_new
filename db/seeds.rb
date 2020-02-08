 # This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Student.create!(name: "Example Student", email: "example@railstutorial.org", password: "foobar", password_confirmation: "foobar", admin: true, activated: true, activated_at: Time.zone.now)

99.times do |n|
  name = Faker::Name.name
  email = "example-#{n+1}@railstutorial.org"
  password = "password"
  Student.create!(name: name, email: email, password: password, password_confirmation: password, activated: true, activated_at: Time.zone.now)
end

School.create!(name:  "Example School",
             email: "example@railstutorial.org",
             password:              "foobar",
             password_confirmation: "foobar", admin: true, activated: true, activated_at: Time.zone.now)

99.times do |n|
  name  = Faker::Name.name
  email = "example-#{n+1}@railstutorial.org"
  password = "password"
  School.create!(name:  name,
               email: email,
               password:              password,
               password_confirmation: password, activated: true, activated_at: Time.zone.now)
end

schools = School.order(:created_at).take(6)
50.times do
  name = Faker::Name.name
  content = Faker::Lorem.sentence(5)
  schools.each { |school| school.events.create!(name: name, content: content) }
end

schools = School.order(:created_at).take(6)
50.times do
  name = Faker::Name.name
  content = Faker::Lorem.sentence(5)
  schools.each { |school| school.laboratories.create!(name: name, content: content, department: 1) }
end

Admin.create!(email: "example@railstutorial.org",
             password:              "foobar",
             password_confirmation: "foobar")

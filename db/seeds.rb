User.create!(name: "Le Tu Anh",
  email: "letuanh@gmail.com",
  password: "123qwe",
  is_admin: true)

20.times do |n|
  name = Faker::Book.genre
  description = Faker::Lorem.sentence(3, true, 4)
  Category.create!(name: name, description: description)
end

20.times do |n|
  name = Faker::GameOfThrones.character
  description = Faker::Lorem.sentence(3, true, 4)
  Author.create!(name: name, description: description)
end

20.times do |n|
  publiser_name = Faker::Company.name
  description = Faker::Lorem.sentence(3, true, 4)
  phone_number = Faker::PhoneNumber.phone_number
  email = Faker::Internet.email
  street_address = Faker::Address.street_address
  city = Faker::Address.city
  street_name = Faker::Address.street_name
  country = Faker::Address.country
  address = "#{street_address}, #{street_name}, #{city}, #{country}"
  Publisher.create!(name: publiser_name, description: description, email: email,
    phone_number: phone_number, address: address)
end

20.times do |n|
  title = Faker::Book.title
  description = Faker::Lorem.sentence(3, true, 4)
  author_id = rand(1..10)
  category_id = rand(1..10)
  publisher_id = rand(1..10)

  Author.create!(name: name, description: description)
end

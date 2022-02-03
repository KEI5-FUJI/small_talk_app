User.create!(
  name: "Keigo",
  email: "keigo@kei.com",
  password: "password",
  password_confirmation: "password",
  admin: true
)

99.times do |n|
  name = Faker::Name.name
  email = "keigo@kei#{n+1}.com"
  password = "password"
  User.create!(
    name: name,
    email: email,
    password: password,
    password_confirmation: password,
    admin: false
  )
end
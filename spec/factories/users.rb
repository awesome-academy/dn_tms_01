FactoryBot.define do
  password = "abc123"

  factory :user do
    email {Faker::Internet.email}
    password {password}
    password_confirmation {password}
    role {User.roles[:trainee]}
    fullname {"Ho va Ten"}
    birthday {Date.new 1994, 12, 28}
    gender {User.genders[:male]}
  end
end

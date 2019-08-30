FactoryBot.define do
   factory :course_user do
       association :course
       association :user
    end

    factory :users do
      sequence(:email) { Faker::Internet.email }
      password {123123}
      password_confirmation {123123}
      role {User.roles[:trainee]}
      fullname {"Ho va Ten"}
      birthday {Date.new 1994, 12, 28}
      gender {User.genders[:male]}

       factory :user_with_courses do

          ignore do
            courses_count 1
          end

          after(:create) do |user, evaluator|
            FactoryGirl.create_list(:course_user, evaluator.courses_count, user: user)
          end
       end
    end

    factory :course do
      name {Faker::Educator.subject}
      description {Faker::Lorem.paragraphs}
      duration {5}
      duration_type {2}
      date_start {"12/12/2020"}
      date_end {"12/12/2021"}
      course_subjects {[CourseSubject.new(subject_id: Subject.first.id)]}

       factory :course_with_user do

          ignore do
            users_count 1
          end

          after(:create) do |registration, evaluator|
            FactoryGirl.create_list(:course_user, evaluator.users_count, course: course)
          end
       end
    end
end

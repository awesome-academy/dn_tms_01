class CourseUser < ApplicationRecord
  # Enums
  enum role: { trainee: 0, supervisor: 1}

  # Relationships
  belongs_to :user
  belongs_to :course
  has_many :subject_users, dependent: :destroy
  has_many :subjects, through: :subject_users

  scope :by_user, ->(user_id){where user_id: user_id}
  scope :by_course_user, ->(course_id, user_id){by_course_id(course_id).
    by_user(user_id)}
  scope :supervisors, ->{where role: CourseUser.roles[:supervisor]}
  delegate :fullname, :email, to: :user

end

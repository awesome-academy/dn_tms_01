class CourseSubject < ApplicationRecord
  enum status: {init: 0, studying: 1, finish: 2}

  belongs_to :course
  belongs_to :subject
  has_many :subject_users
  delegate :picture, to: :subject
  scope :subject_by_course, ->(course_id){where(course_id: course_id)}
end

class CourseUser < ApplicationRecord
  enum role: {trainee: 0, suppervisor: 1}
  enum status: {init: 0, studying: 1, finish: 2}

  belongs_to :user
  belongs_to :course
  has_many :subject_users, dependent: :destroy
  has_many :subjects, through: :subject_users
  delegate :fullname, to: :user
  delegate :name, :description, :duration, :duration_type, :date_end, :date_start,
    :status, to: :course
end

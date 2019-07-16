class SubjectUser < ApplicationRecord
  enum status: {init: 0, studying: 1, finish: 2}

  belongs_to :course_user
  belongs_to :subject
  has_many :progress_user_tasks, dependent: :destroy
  delegate :name, :description, :picture, to: :subject
end

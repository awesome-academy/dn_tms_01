class SubjectTask < ApplicationRecord
  belongs_to :task
  belongs_to :subject

  has_many :progress_user_tasks, dependent: :destroy
  delegate :name, to: :task
end

class Subject < ApplicationRecord
  enum status: {init: 0, studying: 1, finish: 2}

  has_many :course_subjects, dependent: :destroy
  has_many :subject_users, dependent: :destroy
  has_many :tasks, dependent: :destroy

  accepts_nested_attributes_for :course_subjects, allow_destroy: true
  accepts_nested_attributes_for :tasks, allow_destroy: true

  validates :name, presence: true,
            length: {maximum: Settings.name_length_maximum}

  validates :description, presence: true,
            length: {maximum: Settings.content_text_max_length}

  mount_uploader :picture, PictureUploader

  scope :newest, ->{order id: :desc}
end

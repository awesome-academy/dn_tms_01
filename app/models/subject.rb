class Subject < ApplicationRecord
  # Enums
  has_many :course_subjects, dependent: :destroy
  has_many :subject_users, dependent: :destroy
  has_many :tasks, dependent: :destroy

  # Relationships
  accepts_nested_attributes_for :course_subjects, allow_destroy: true
  accepts_nested_attributes_for :tasks, allow_destroy: true

  # Validates
  validates :name, presence: true,
<<<<<<< HEAD
    length: {maximum: Settings.name_length_maximum, minimum: Settings.name_length_minimum}

=======
    length: {maximum: Settings.name_length_maximum,
      minimum: Settings.name_length_minimum}
>>>>>>> edit template
  validates :description, presence: true,
    length: {maximum: Settings.content_text_max_length}

  # Uploader
  mount_uploader :picture, PictureUploader

  # Query options
  scope :newest, ->{order id: :desc}
end

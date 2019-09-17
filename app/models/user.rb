class User < ApplicationRecord
  include UserHelper

  # Enums
  enum role: {trainee: 0, supervisor: 1}
  enum gender: {male: 1, female: 0}

  # Relationships
  has_many :course_users, dependent: :destroy
  has_many :courses, through: :course_users

  # Validates
  validates :fullname, presence: true,
    length: {maximum: Settings.fullname_length_maximum}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true,
    length: {minimum: Settings.email_length_minimum,
             maximum: Settings.email_length_maximum},
    format: {with: VALID_EMAIL_REGEX},
    uniqueness: {case_sensitive: false}
  validates :password, length: {minimum: Settings.password_length_minimum},
    allow_nil: true
  validates :birthday, presence: true

  # Custom validates
  validate do
    birthday_must_smaller_x_year
  end

  # Uploader
  mount_uploader :avatar, PictureUploader

  # Hash password
  has_secure_password

  # Query options
  scope :newest, ->{order id: :desc}
  scope :order_role, ->{order role: :desc}
  scope :byId, ->(id){where id: id}

  class << self
    def role_types_i18n
      Hash[User.roles.map{|k, _v| [I18n.t("user.role.#{k}"), k]}]
    end

    def gender_types
      Hash[User.genders.map{|k, _v| [I18n.t("user.gender.#{k}"), k]}]
    end
  end

  private

  def birthday_must_smaller_x_year
    return if birthday.nil? || age(birthday) >= Settings.age_valid
    errors.add(:birthday, :birthday_invalid)
  end
end

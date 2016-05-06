class User < ActiveRecord::Base
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  before_save {self.email = email.downcase} #make sure the email is in downcase before saving tto the DB
  validates :name, presence: true, length: {maximum: 40}
  validates :email, presence: true, length: {maximum: 200}, format: {with: VALID_EMAIL_REGEX}, uniqueness: {case_sensitive: false}
  has_secure_password
  validates :password, presence: true, length: {minimum: 8}
end

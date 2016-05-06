class User < ActiveRecord::Base
  #We need a way to make a token available
  #via user.remember_token (for storage in the cookies) without storing it in
  #the database. like password with password_digest from has_secure_password helper. but now we make it manually
  attr_accessor :remember_token

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  before_save {self.email = email.downcase} #make sure the email is in downcase before saving tto the DB
  validates :name, presence: true, length: {maximum: 40}
  validates :email, presence: true, length: {maximum: 200}, format: {with: VALID_EMAIL_REGEX}, uniqueness: {case_sensitive: false}
  has_secure_password
  validates :password, presence: true, length: {minimum: 8}

  # Returns the hash digest of the given string.
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # Returns a random token.
  def User.new_token
    #The urlsafe_base64 method from the SecureRandom module in the Ruby standard library
    #returns a random string of length 22 composed of the characters A–Z, a–z, 0–9, “-”, and “_”
    #(for a total of 64 possibilities, thus “base64”)
    #example:
    #$ rails console
    #>> SecureRandom.urlsafe_base64
    #=> "q5lt38hQDc_959PVoo6b7A"
    SecureRandom.urlsafe_base64
  end

  # Remembers a user in the database for use in persistent sessions
  def remember
    self.remember_token = User.new_token #Using self ensures that assignment sets the user’s remember_token attribute.

    #this method bypasses the validations, which is necessary
    #in this case because we don’t have access to the user’s
    #password or confirmation.
    update_attribute(:remember_digest,  User.digest(remember_token) )
  end

  # Returns true if the given token matches the digest.
  def authenticated?(remember_token)
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end

  # Forgets a user. to be able to logout
  def forget
    update_attribute(:remember_digest, nil)
  end
end

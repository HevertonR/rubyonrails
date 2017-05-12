class User < ApplicationRecord
  attr_accessor :remember_token, :activation_token
  before_save  :downcase_email
  before_create :create_activation_digest 
  validates :name,  presence: true, length: { maximum: 50 }
  VALIDACAO_EMAIL = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 }, format: { with: VALIDACAO_EMAIL }, uniqueness: { case_sensitive: false }

 has_secure_password
 validates :password, presence: true, length: { minimum: 6 }, allow_nil: true
 validates :password_confirmation, presence: true

# Returns the hash digest of the given string.
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
 
 def User.new_token
  SecureRandom.urlsafe_base64
 end

 private

 def downcase_email
  self.email = email.downcase
 end

 def create_activation_digest
  self.activation_token = User.new_token
  self.activation_digest = User.digest(activation_token)
 end
end

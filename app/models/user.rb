class User < ApplicationRecord
  #has_many
  has_many :microposts, dependent: :destroy
  has_many :active_relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower
  has_many :passive_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy  

  attr_accessor :remember_token, :activation_token, :reset_token
  before_save  :downcase_email
  before_create :create_activation_digest 
  validates :name,  presence: true, length: { maximum: 50 }
  VALIDACAO_EMAIL = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 }, format: { with: VALIDACAO_EMAIL }, uniqueness: { case_sensitive: false }

 has_secure_password
 validates :password, presence: true, length: { minimum: 6 }, allow_nil: true
 validates :password_confirmation, presence: true

 def forget
  update_attribute(:remember_digest, nil)
 end

 def create_reset_digest
  self.reset_token = User.new_token
  update_attribute(:reset_digest, User.digest(reset_token))
  update_attribute(:reset_sent_at, Time.zone.now)
 end

 def password_reset_expired?
  reset_sent_at < 2.hours.ago
 end 
 
 def send_password_reset_email
  UserMailer.password_reset(self).deliver_now
 end
  
 def create_activation_digest
  self.activation_token = User.new_token
  self.activation_digest = User.digest(activation_token)
 end
  
 def feed
  Micropost.where("user_id = ?", id)
 end

 def follow(other_user)
  following << other_user
 end
 
 def unfollow(other_user)
  following.delete(other_user)
 end

 def following?(other_user)
  following.include?(other_user)
 end

 def downcase_email
  self.email = email.downcase
 end

   class << self
# Returns the hash digest of the given string.
  #def User.digest(string)
  def digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

 #def User.new_token
 def new_token
  SecureRandom.urlsafe_base64
 end

 def remember
  self.remember_token = User.new_token
  update_attribute(:remember_digest, User.digest(remember_token))
 end
 
 def authenticated?(remember_token)
  return false if remember_digest.nil?
  BCrypt::Password.new(remember_digest).is_password?(remember_token)
 end

end
end

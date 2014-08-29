class User < ActiveRecord::Base
  attr_reader :password
  
  validates :username, :password_digest, :session_token, presence: true
  validates :username, uniqueness: true
  
  validates :password, length: { minimum: 6, allow_nil: true }
  
  after_initialize :ensure_session_token


  def self.find_user_by_credentials(username, password)
    user = User.find_by(username: username)
    return nil if user.nil?
    user.password_digest.is_password?(password) ? user : nil
  end

  
  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end
  
  def ensure_session_token
    self.session_token ||= generate_session_token
  end
  
  def is_password?(password)
    BCrypt::Password.new(password_digest).is_password?(password)
  end
  
  def generate_session_token
    SecureRandom::urlsafe_base64
  end
  
  def reset_session_token
    # for signing out. 
    self.session_token = generate_session_token
    session[:session_token] = nil
  end
  
end

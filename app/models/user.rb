class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and 
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable
  include User::NoPassword
  include User::OauthFacebook
  include User::OauthTwitter
  include User::OauthVkontakte

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :username, :role, :avatar, :remote_avatar_url
  attr_writer :remote_avatar_url
  # attr_accessible :title, :body
  validates :username, :uniqueness => true, :presence => true

  mount_uploader :avatar, AvatarUploader

  def to_param
    "#{id}-#{username}"
  end

end

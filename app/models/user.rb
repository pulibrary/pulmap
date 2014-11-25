class User < ActiveRecord::Base

# Connects this user object to Blacklights Bookmarks. 
  include Blacklight::User
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable

  devise :omniauthable

  # Method added by Blacklight; Blacklight uses #to_s on your
  # user class to get a user-displayable login/identifier for
  # the account.
  def to_s
    username
  end

  def self.find_for_cas(access_token, signed_in_resource=nil)
    logger.debug "#{access_token.inspect}"
    username = access_token.uid
    user = User.where(:username => username).first

    unless user
        user = User.create(username: username)
    end
    user
  end
end

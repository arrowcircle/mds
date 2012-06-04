#coding: utf-8
module User::OauthFacebook
  def self.included(base)
    base.extend(ClassMethods)
  end
  module ClassMethods
    def find_for_facebook_oauth(access_token, signed_in_resource=nil)
      data = access_token.extra.raw_info
      if user = self.find_by_email(data.email)
        user
      else # Create a user with a stub password. 
        self.create!(:email => data.email, :password => Devise.friendly_token[0,20], :username => access_token.info.nickname, :remote_avatar_url => access_token.info.image) 
      end
    end
  end
end
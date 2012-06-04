#coding: utf-8
module User::OauthTwitter
  def self.included(base)
    base.extend(ClassMethods)
  end
  module ClassMethods
    def find_for_twitter_oauth(access_token, signed_in_resource=nil)
      data = access_token#.extra.raw_info
      if user = self.find_by_username(data.info.nickname)
        user
      else # Create a user with a stub password. 
        self.create!(:email => SecureRandom.hex(16)+"@mds.redde.ru", :password => Devise.friendly_token[0,20], :username => data.info.nickname, :remote_avatar_url => data.info.image) 
      end
    end
  end
end
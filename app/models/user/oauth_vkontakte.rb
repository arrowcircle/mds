#coding: utf-8
module User::OauthVkontakte
  def self.included(base)
    base.extend(ClassMethods)
  end
  module ClassMethods
    def find_for_vkontakte_oauth(access_token, signed_in_resource=nil)
      data = access_token#.extra.raw_info
      username = data.info.nickname
      username = "#{data.info.last_name}-#{data.info.first_name}" unless username.present?
      if user = self.find_by_username(data.info.nickname)
        user
      else # Create a user with a stub password.
        self.create!(:email => username+"@mds.redde.ru", :password => Devise.friendly_token[0,20], :username => username, :remote_avatar_url => data.info.image)
      end
    end
  end
end
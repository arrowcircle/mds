class UserPageComponent < ViewComponent::Base
  Icon = Data.define(:title, :icon)
  attr_reader :user
  def initialize(user)
    @user = user
  end

  def buttons
    []
  end

  def title
    @user.username
  end

  def metadata
    res = [Icon.new(title: "#{time_ago_in_words(@user.created_at)} на сайте", icon: "images/time.svg")]
    res << Icon.new(title: "Опознал треков: #{@user.playlists_count}", icon: "images/upload.svg") if @user.playlists_count > 0
    res << Icon.new(title: "Запросы на опознание: #{@user.requests_count}", icon: "images/download.svg") if @user.requests_count > 0
    res
  end
end

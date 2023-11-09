class ArtistItemComponent < ViewComponent::Base
  attr_reader :artist, :current_user

  def initialize(item:, current_user:)
    @artist = item
    @current_user = current_user
  end

  def self.headers
    ["Имя", ""]
  end
end

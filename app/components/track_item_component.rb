class TrackItemComponent < ViewComponent::Base
  attr_reader :track, :current_user

  def initialize(item:, current_user:)
    @track = item
    @current_user = current_user
  end

  def self.headers
    ["Название", ""]
  end
end

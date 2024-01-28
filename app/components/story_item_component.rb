class StoryItemComponent < ViewComponent::Base
  attr_reader :story, :current_user

  def initialize(item:, current_user:)
    @story = item
    @current_user = current_user
  end

  def self.headers
    ["Название", ""]
  end
end

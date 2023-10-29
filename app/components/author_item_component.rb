class AuthorItemComponent < ViewComponent::Base
  attr_reader :author, :current_user

  def initialize(item:, current_user:)
    @author = item
    @current_user = current_user
  end

  def self.headers
    ["Имя", ""]
  end
end

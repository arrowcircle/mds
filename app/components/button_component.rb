class ButtonComponent < ViewComponent::Base
  def initialize(title:, link:, classes: [], icon: nil)
    @title = title
    @icon = icon
    @link = link
    @classes = classes
  end
end

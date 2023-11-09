class PageTitleButtonComponent < ViewComponent::Base
  attr_reader :mobile_visible, :title, :link
  def initialize(title:, link:, icon: nil, inline_svg: nil, mobile_visible: true)
    @title = title
    @icon = icon
    @link = link
    @inline_svg = inline_svg
    @mobile_visible = mobile_visible
  end

  def classes
    return [] if mobile_visible
    ["hidden"]
  end
end

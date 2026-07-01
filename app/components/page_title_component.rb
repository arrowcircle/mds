class PageTitleComponent < ViewComponent::Base
  def initialize(title:, breadcrumbs: [], buttons: [], metadata: [])
    @title = title
    @breadcrumbs = breadcrumbs
    @buttons = buttons
    @metadata = metadata
  end

  def mobile_dropdown_buttons
    @dropdown_buttons ||= @buttons.select { !it.mobile_visible }
  end
end

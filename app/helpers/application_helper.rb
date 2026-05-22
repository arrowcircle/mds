# frozen_string_literal: true

module ApplicationHelper
  include Pagy::Frontend

  ICONS_PATH = Rails.root.join("app/javascript/images")

  def inline_icon_tag(icon, **attributes)
    icon_path = icon_path_for(icon)
    document = Nokogiri::XML(icon_path.read)
    svg = document.at_css("svg")

    attributes[:class] = ["theme-icon", attributes[:class]].compact.join(" ")
    attributes.each do |name, value|
      svg[name.to_s.tr("_", "-")] = value.to_s
    end
    svg["aria-hidden"] ||= "true"
    svg["focusable"] ||= "false"

    raw svg.to_xml
  end

  private

  def icon_path_for(icon)
    path = ICONS_PATH.join(icon.to_s.delete_prefix("images/")).cleanpath
    raise ArgumentError, "Icon must be inside app/javascript/images" unless path.to_s.start_with?(ICONS_PATH.to_s)
    raise ArgumentError, "Unknown icon: #{icon}" unless path.file?

    path
  end
end

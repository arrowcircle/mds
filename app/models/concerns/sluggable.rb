module Sluggable
  extend ActiveSupport::Concern

  def to_param
    slug = Russian.translit(name)
      .tr(" ", "-")
      .gsub(/[^\x00-\x7F]+/, "")
      .gsub(/[^\w_ \-]+/i, "")
      .gsub(/[ \-]+/i, "-")
      .gsub(/^-|-$/i, "")
      .downcase
    "#{id}-#{slug}"
  end
end

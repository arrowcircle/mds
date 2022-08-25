# frozen_string_literal: true

module OpengraphHelper
  def facebook_opengraph(options = {})
    {
      "og:title" => title,
      "og:type" => "website",
      "og:url" => request.original_url,
      "og:image" => card_image,
      "og:description" => description,
      "og:site_name" => "МДС Музыка",
      "og:locale" => "ru_RU"
    }.merge(options)
  end

  def twitter_cards(options = {})
    {
      "twitter:card" => "summary_large_image",
      "twitter:title" => title,
      "twitter:description" => description,
      "twitter:image:src" => card_image
    }.merge(options)
  end

  def card_image
    ""
  end
end

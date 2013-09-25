# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = "http://mds.redde.ru"

SitemapGenerator::Sitemap.create do
  add '/', :changefreq => 'daily'
  add '/authors'
  add '/artists'
  add '/tags', :changefreq => 'daily'
  add '/recent', :changefreq => 'daily'
  add '/recent/identified'
  add '/recent/requests'

  Author.find_each do |author|
    add author_stories_path(author)
    author.stories.find_each do |story|
      add author_story_path(author, story)
    end
  end
  Artist.find_each do |artist|
    add artist_tracks_path(artist)
    artist.tracks.find_each do |track|
      add artist_track_path(artist, track)
    end
  end

  # Put links creation logic here.
  #
  # The root path '/' and sitemap index file are added automatically for you.
  # Links are added to the Sitemap in the order they are specified.
  #
  # Usage: add(path, options={})
  #        (default options are used if you don't specify)
  #
  # Defaults: :priority => 0.5, :changefreq => 'weekly',
  #           :lastmod => Time.now, :host => default_host
  #
  # Examples:
  #
  # Add '/articles'
  #
  #   add articles_path, :priority => 0.7, :changefreq => 'daily'
  #
  # Add all articles:
  #
  #   Article.find_each do |article|
  #     add article_path(article), :lastmod => article.updated_at
  #   end
end

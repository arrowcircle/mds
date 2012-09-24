#coding: utf-8
module PlaylistsHelper

  def link_to_artist_track playlist
    if playlist.track_id
      # we got identified playlist
      artist = playlist.track.artist
      track = playlist.track
      c = raw "#{link_to artist.name, [artist, :tracks]} - #{link_to track.name, [artist, track]}"
    else
      # we have requested playlist
      raw "<strong>Запрос на опознание</strong>"
    end
  end

  def search_links playlist
    if playlist.try(:track)
      search = raw "Искать на: "
      discogs = link_to image_tag("http://www.discogs.com/favicon.ico", :size => "13x13"), "http://www.discogs.com/search?q=#{playlist.track.full_name}&type=all", :target => "_blank", :alt => 'Discogs.com'
      vk = link_to image_tag("http://vkontakte.ru/favicon.ico", :size => "13x13"), "http://vk.com/audio?q=#{playlist.track.full_name}", :target => "_blank", :alt => "vk.com"
      gs = link_to image_tag("http://grooveshark.com/webincludes/images/favicon.ico", :size => "13x13"), "http://grooveshark.com/#!/search?q=#{playlist.track.full_name}", :target => "_blank", :alt => "Grooveshark.com"
      ya = link_to image_tag("http://music.yandex.ru/favicon.ico", :size => "13x13"), "http://music.yandex.ru/#!/search?text=#{playlist.track.full_name}", :target => "_blank", :alt => "Яндекс.Музыка"
      search + discogs + vk + gs + ya
    end
  end

  def link_to_playlist_user playlist
    user = playlist.identifier
    if user
      link_to user.username, user
    end
  end
end
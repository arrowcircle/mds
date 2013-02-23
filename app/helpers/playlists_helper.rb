#coding: utf-8
module PlaylistsHelper

  def identified_by_helper playlist
    if playlist.identified_by
      playlist.identified_by
    else
      current_user.id
    end
  end

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

  def discogs_search playlist
    link_to "", "http://www.discogs.com/search?q=#{playlist.track.full_name}&type=all", :target => "_blank", :title => 'Discogs.com', class: "ico-msocial"
  end

  def vk_search playlist
    link_to "", "http://vk.com/audio?q=#{playlist.track.full_name}", :target => "_blank", :title => "vk.com", class: "ico-msocial"
  end

  def grooveshark_search playlist
    link_to "", "http://grooveshark.com/#!/search?q=#{playlist.track.full_name}", :target => "_blank", :title => "Grooveshark.com", class: "ico-msocial"
  end

  def ya_search playlist
    link_to "", "http://music.yandex.ru/#!/search?text=#{playlist.track.full_name}", :target => "_blank", :title => "Яндекс.Музыка", class: "ico-msocial"
  end

  def muzebra_search playlist
    link_to "", "http://muzebra.com/search/?q=#{playlist.track.full_name}", :target => "_blank", :title => "Muzebra.com", class: "ico-msocial"
  end


  def search_links playlist
    if playlist.try(:track)
      search = raw "Искать на: "
      search + discogs_search(playlist) + vk_search(playlist) + grooveshark_search(playlist) + ya_search(playlist) + muzebra_search(playlist)
    end
  end

  def link_to_playlist_user playlist
    user = playlist.identifier
    if user
      link_to user.username, user
    end
  end
end
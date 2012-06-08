#coding: utf-8
module PlaylistsHelper

  def link_to_artist_track playlist
    if playlist.track_id
      # we got identified playlist
      artist = playlist.track.artist
      track = playlist.track
      raw "#{link_to artist.name, artist} - #{link_to track.name, artist}"
    else
      # we have requested playlist
      raw "<strong>Запрос на опознание</strong>"
    end
  end

  def link_to_playlist_user playlist
    user = playlist.identifier
    if user
      link_to user.username, user
    end
  end
end
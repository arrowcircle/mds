#coding: utf-8
module TracksHelper
  def track_header_link track
    raw "#{link_to track.try(:artist).try(:name), [track.try(:artist), :tracks]} - #{track.name}"
  end
end
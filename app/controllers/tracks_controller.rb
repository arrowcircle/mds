#coding: utf-8
class TracksController < ApplicationController
  before_filter :get_artist
  def search
    @tracks = @artist.tracks.search params[:term]
    render :json => @tracks.map(&:name)
  end

  private
  def get_artist
    @artist = Artist.find(params[:artist_id])
  end
end
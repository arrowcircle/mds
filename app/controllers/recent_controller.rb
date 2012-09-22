#coding: utf-8
class RecentController < ApplicationController
  def index
    @playlists = Playlist.includes([:story => :author, :track => :artist], :identifier).order("updated_at DESC").page(params[:page]).per(20)
    @header = "Новости"
  end

  def requests
    @playlists = Playlist.requests.order("updated_at DESC").page(params[:page]).per(20)
    @header = "Новые запросы"
    render "index"
  end

  def identified
    @playlists = Playlist.includes([:story, :track]).identified.order("updated_at DESC").page(params[:page]).per(20)
    @header = "Новые опознания"
    render "index"
  end
end
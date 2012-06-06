#coding: utf-8
class ArtistsController < ApplicationController
  def search
    @artists = Artist.search params[:term]
    render :json => @artists.select([:id, :name])
  end
end
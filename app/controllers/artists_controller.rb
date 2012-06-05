#coding: utf-8
class ArtistsController < ApplicationController
  def search
    @artists = Artist.search params[:term]
    render :json => @artists.map(&:name)
  end
end
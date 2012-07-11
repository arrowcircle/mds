#coding: utf-8
class MainController < ApplicationController
  def index
  end

  def login
  end

  def search
    if params[:search].present?
      @authors = Author.search(params[:search])
      @stories = Story.search(params[:search])
      @artists = Artist.search(params[:search])
      @tracks = Track.search(params[:search])
    else
    end
  end

end
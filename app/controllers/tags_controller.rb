#coding: utf-8
class TagsController < ApplicationController
  def index
    @tags = ActsAsTaggableOn::Tag.all
  end

  def show
    @stories = Story.includes(:author).tagged_with(params[:name]).page(params[:page]).per(20)
  end
end
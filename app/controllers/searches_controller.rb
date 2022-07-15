class SearchesController < ApplicationController
  def index
    @results = Search.search(params[:q])
  end
end

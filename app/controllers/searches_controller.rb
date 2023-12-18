class SearchesController < ApplicationController
  def index
    @results = Search.search(params[:q])
    render :index, status: :see_other
  end
end

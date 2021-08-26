class AuthorsController < ApplicationController
  def index
    @pagy, @authors = pagy(Author.all)
  end

  def show
    @author = Author.find(params[:id])
  end
end

 #coding: utf-8
class AuthorsController < ApplicationController
  # GET /authors
  # GET /authors.json
  def index
    @authors = Author.search(params[:search]).page(params[:page]).per(20)
    @author = Author.new
  end

  # GET /authors/1
  # GET /authors/1.json
  def show
    @author = Author.find(params[:id])
    if @author
      redirect_to [@author, :stories]
    else
      redirect_to authors_path
    end
  end

  # GET /authors/new
  # GET /authors/new.json
  def new
    @author = Author.new
    render "form"
  end

  # GET /authors/1/edit
  def edit
    @author = Author.find(params[:id])
    render "form"
  end

  # POST /authors
  # POST /authors.json
  def create
    @author = Author.new(params[:author])
    if @author.save
      redirect_to [@author, :stories], notice: 'Автор добавлен. Теперь добавьте рассказ.'
    else
      render "new"
    end
  end

  # PUT /authors/1
  # PUT /authors/1.json
  def update
    @author = Author.find(params[:id])
    if @author.update_attributes(params[:author])
      redirect_to @author, notice: 'Author was successfully updated.'
    else
      render action: "edit" 
    end
  end

  # DELETE /authors/1
  # DELETE /authors/1.json
  def destroy
    @author = Author.find(params[:id])
    @author.destroy
    redirect_to authors_url
  end
end

class SearchesController < ApplicationController
  def index
    @results = Search.search(params[:q])
    render :index, status: :see_other
  end

  private

  def title
    return "Поиск: #{params[:q]}" if params[:q].present?

    "Поиск"
  end

  def description
    return "Результаты поиска по запросу #{params[:q]} в плейлистах МДС Музыка" if params[:q].present?

    "Поиск авторов, рассказов, исполнителей и треков из радиопередачи Модель для Сборки"
  end

  def tags
    "мдс, модель для сборки, поиск, что играет, опознать трек, музыка, плейлист"
  end
end

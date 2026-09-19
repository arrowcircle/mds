# frozen_string_literal: true

require "rails_helper"
require "passwordless/test_helpers"

RSpec.describe "SEO metadata", type: :request do
  include Passwordless::TestHelpers::RequestTestCase

  def head_tags
    html = Nokogiri::HTML(response.body)
    {
      title: html.at_css("title")&.text,
      description: html.at_css('meta[name="description"]')&.[]("content"),
      keywords: html.at_css('meta[name="keywords"]')&.[]("content"),
      og_title: html.at_css('meta[property="og:title"]')&.[]("content"),
      og_description: html.at_css('meta[property="og:description"]')&.[]("content"),
      twitter_title: html.at_css('meta[property="twitter:title"]')&.[]("content")
    }
  end

  it "renders story-specific metadata" do
    author = create(:author, name: "Максим Кабир")
    story = create(:story, author:, name: "Жирным шрифтом и долбаным курсивом")

    get author_story_path(author, story)

    expect(head_tags).to include(
      title: "Жирным шрифтом и долбаным курсивом - Максим Кабир | МДС Музыка",
      description: "Максим Кабир - Жирным шрифтом и долбаным курсивом плейлист | МДС Музыка",
      og_title: "Жирным шрифтом и долбаным курсивом - Максим Кабир",
      og_description: "Максим Кабир - Жирным шрифтом и долбаным курсивом плейлист",
      twitter_title: "Жирным шрифтом и долбаным курсивом - Максим Кабир"
    )
    expect(head_tags[:keywords]).to include("музыка из рассказа Максим Кабир Жирным шрифтом и долбаным курсивом")
  end

  it "renders author-specific metadata" do
    author = create(:author, name: "Рэй Брэдбери")

    get author_path(author)

    expect(head_tags).to include(
      title: "Рэй Брэдбери | МДС Музыка",
      description: "Рассказы Рэй Брэдбери и музыка из них в радиопередаче Модель для Сборки | МДС Музыка",
      og_title: "Рэй Брэдбери",
      og_description: "Рассказы Рэй Брэдбери и музыка из них в радиопередаче Модель для Сборки"
    )
    expect(head_tags[:keywords]).to include("музыка из рассказа, Рэй Брэдбери")
  end

  it "renders artist-specific metadata" do
    artist = Artist.create!(name: "Boards of Canada")

    get artist_path(artist)

    expect(head_tags).to include(
      title: "Boards of Canada | МДС Музыка",
      description: "Треки Boards of Canada, звучавшие в рассказах радиопередачи Модель для Сборки | МДС Музыка",
      og_title: "Boards of Canada"
    )
    expect(head_tags[:keywords]).to include("Boards of Canada")
  end

  it "renders track-specific metadata" do
    artist = Artist.create!(name: "Autechre")
    track = artist.tracks.create!(name: "Rae")

    get artist_track_path(artist, track)

    expect(head_tags).to include(
      title: "Rae - Autechre | МДС Музыка",
      description: "Autechre - Rae: рассказы радиопередачи Модель для Сборки, где звучит этот трек | МДС Музыка",
      og_title: "Rae - Autechre"
    )
    expect(head_tags[:keywords]).to include("Autechre, Rae")
  end

  it "renders list-page metadata" do
    create(:author, name: "Автор")

    get authors_path

    expect(head_tags).to include(
      title: "Авторы | МДС Музыка",
      description: "Страница со списком авторов рассказов игравших в радиопередаче Модель Для Сборки | МДС Музыка",
      og_title: "Авторы"
    )
  end

  it "renders add-author page without a nil title" do
    passwordless_sign_in(create(:user))

    get new_author_path

    expect(response).to have_http_status(:ok)
    expect(head_tags).to include(
      title: "Добавить автора | МДС Музыка",
      og_title: "Добавить автора"
    )
  end

  it "renders add-artist page without a nil title" do
    passwordless_sign_in(create(:user))

    get new_artist_path

    expect(response).to have_http_status(:ok)
    expect(head_tags).to include(
      title: "Добавить артиста | МДС Музыка",
      og_title: "Добавить артиста"
    )
  end

  it "renders user-specific metadata" do
    user = create(:user, username: "arrowcircle")

    get user_path(user)

    expect(head_tags).to include(
      title: "arrowcircle | Участники проекта | МДС Музыка",
      description: "arrowcircle | Страница участника проекта | МДС Музыка",
      og_title: "arrowcircle | Участники проекта"
    )
  end

  it "renders the modern favicon links" do
    get root_path

    html = Nokogiri::HTML(response.body)

    expect(html.at_css('link[rel="icon"][href="/favicon.ico"][sizes="32x32"]')).to be_present
    expect(html.at_css('link[rel="icon"][href="/icon.svg"][type="image/svg+xml"]')).to be_present
    expect(html.at_css('link[rel="apple-touch-icon"][href="/apple-touch-icon.png"]')).to be_present
    expect(html.at_css('link[rel="manifest"][href="/manifest.webmanifest"]')).to be_present
  end

  it "serves non-empty favicon assets" do
    %w[
      favicon.ico
      icon.svg
      apple-touch-icon.png
      icon-192.png
      icon-mask.png
      icon-512.png
      manifest.webmanifest
    ].each do |path|
      get "/#{path}"

      expect(response).to have_http_status(:ok)
      expect(response.body.bytesize).to be > 0
    end
  end
end

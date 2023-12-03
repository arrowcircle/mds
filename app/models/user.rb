# frozen_string_literal: true

class User < ApplicationRecord
  validates :username, presence: true, uniqueness: true, allow_blank: false, length: {minimum: 2}
  validates :email, presence: true, uniqueness: {case_sensitive: false}, email: {mode: :strict, require_fqdn: true}
  normalizes :email, with: -> { _1.strip.downcase }

  passwordless_with :email

  has_many :playlists
  has_many :identified_playlists, class_name: "Playlist", foreign_key: :identified_by, inverse_of: :identifier

  ADMINS = %w[
    siawlad@narod.ru
    myla@pokanetu.ru
    hell.nmi@gmail.com
    zarrazzaa@yandex.ru
    spacejunkdrone808@gmail.com
    angredde@yandex.ru
    klon2@mail.ru
    dodik_kotkin@mail.ru
    flaer-89@mail.ru
    firtual@mail.ru
    noname@pochta.ru
    t.minelab@gmail.com
    fox_bomb@hotbox.ru
    needsomemiracle@gmail.com
    povan@ya.ru
    upmusic27@mail.ru
    4registrazzio@rambler.ru
    slash-dj@ya.ru
  ]

  include ImageUploader::Attachment(:avatar)

  def self.search(query)
    if query && query.length > 0
      where("username ILIKE ?", "%#{query}%").order(playlists_count: :desc)
    else
      order(playlists_count: :desc)
    end
  end

  def to_param
    "#{id}-#{slug}"
  end

  def slug
    @slug ||= username.strip.tr(" ", "-")
      .gsub(/[^\x00-\x7F]+/, "")
      .gsub(/[^\w_ -]+/i, "")
      .gsub(/[ -]+/i, "-")
      .gsub(/^-|-$/i, "")
  end

  def requests_count
    playlists.where(track_id: nil).count
  end

  def admin?
    ADMINS.include?(email.downcase.strip)
  end
end

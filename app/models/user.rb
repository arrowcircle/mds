# frozen_string_literal: true

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable, :lockable
  validates :username, presence: true, uniqueness: true, allow_blank: false, length: { minimum: 3 }

  include ImageUploader::Attachment.new(:avatar)

  def self.search(query)
    if query && query.length > 0
      where('username ILIKE ?', "%#{query}%").order('last_sign_in_at DESC')
    else
      order('last_sign_in_at DESC')
    end
  end

  def to_param
    "#{id}-#{slug}"
  end

  def slug
    @slug ||= username.strip.tr(' ', '-')
      .gsub(/[^\x00-\x7F]+/, '')
      .gsub(/[^\w_ \-]+/i, '')
      .gsub(/[ \-]+/i, '-')
      .gsub(/^\-|\-$/i, '')
  end

  def requests_count
    rand(100)
  end

  def findings_count
    rand(100)
  end
end

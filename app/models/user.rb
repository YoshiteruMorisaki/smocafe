class User < ApplicationRecord
  has_secure_password

  has_many :sessions, dependent: :destroy
  has_many :reports, dependent: :destroy
  has_many :bookmarks, dependent: :destroy
  has_many :bookmarked_shops, through: :bookmarks, source: :shop

  validates :name, presence: true
  validates :email_address, presence: true, uniqueness: true
  validates :password, length: { minimum: 6 }, allow_blank: true
  validates :is_active, inclusion: { in: [true, false] }

  normalizes :email_address, with: ->(email) { email.strip.downcase }

  def bookmarked?(shop)
    bookmarks.exists?(shop_id: shop.id)
  end
end

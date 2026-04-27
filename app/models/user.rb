class User < ApplicationRecord
  has_secure_password

  has_many :sessions, dependent: :destroy
  has_many :reports, dependent: :destroy
  has_many :bookmarks, dependent: :destroy
  has_many :bookmarked_shops, through: :bookmarks, source: :shop

  has_one_attached :profile_image

  validates :name, presence: true
  validates :email_address, presence: true, uniqueness: true
  # allow_blank: true でパスワード未入力時のバリデーションをスキップ（プロフィール更新時に不要な検証をしない）
  validates :password, length: { minimum: 6 }, allow_blank: true
  validates :is_active, inclusion: { in: [ true, false ] }

  # normalizes: 保存前にメールアドレスを正規化（前後の空白除去・小文字化）
  # find_by など検索時にも自動適用されるため大文字小文字の揺れを吸収できる
  normalizes :email_address, with: ->(email) { email.strip.downcase }

  def display_profile_image
    profile_image.attached? ? profile_image : nil
  end
end

class Admin < ApplicationRecord
  has_secure_password

  has_many :sessions, dependent: :destroy

  validates :email_address, presence: true, uniqueness: true
  validates :password, length: { minimum: 6 }, allow_blank: true

  normalizes :email_address, with: ->(email) { email.strip.downcase }
end

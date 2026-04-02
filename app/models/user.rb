class User < ApplicationRecord
  has_secure_password

  has_many :sessions, dependent: :destroy

  validates :name, presence: true
  validates :email_address, presence: true, uniqueness: true
  validates :password, length: { minimum: 6 }, allow_blank: true
  validates :is_active, inclusion: { in: [true, false] }

  normalizes :email_address, with: ->(email) { email.strip.downcase }
end

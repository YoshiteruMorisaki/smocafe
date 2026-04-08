class Shop < ApplicationRecord
  AREAS = %w[東京 上野 新宿 渋谷 原宿].freeze

  has_one_attached :image

  enum :heated_tobacco_status, { unknown: 0, allowed: 1, disallowed: 2 }, prefix: true
  enum :papper_tobacco_status, { unknown: 0, allowed: 1, disallowed: 2 }, prefix: true

  validates :name, :area, :address, presence: true
  validates :area, inclusion: { in: AREAS }
  validates :heated_tobacco_status, :papper_tobacco_status, presence: true
  validates :wifi_available, :power_available, inclusion: { in: [true, false] }

  scope :by_area, ->(area) { where(area: area) }
  scope :newest_first, -> { order(created_at: :desc, id: :desc) }
  scope :recent_first, -> { order(last_reported_at: :desc, updated_at: :desc, id: :desc) }

  def heated_tobacco_status_i18n
    self.class.human_enum_name(:heated_tobacco_status, heated_tobacco_status)
  end

  def papper_tobacco_status_i18n
    self.class.human_enum_name(:papper_tobacco_status, papper_tobacco_status)
  end

  def display_image
    image.attached? ? image : "No_image.jpg"
  end
end

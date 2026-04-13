class Report < ApplicationRecord
  belongs_to :user
  belongs_to :shop

  after_commit :sync_last_reported_at_for_related_shops, on: [:create, :update]
  after_commit :sync_last_reported_at_for_destroyed_shop, on: :destroy

  enum :heated_tobacco_status, { unknown: 0, allowed: 1, disallowed: 2 }, prefix: true
  enum :papper_tobacco_status, { unknown: 0, allowed: 1, disallowed: 2 }, prefix: true

  validates :visited_on, presence: true
  validates :heated_tobacco_status, :papper_tobacco_status, presence: true
  validates :comment, presence: true, length: { maximum: 1_000 }

  scope :newest_first, -> { order(created_at: :desc, id: :desc) }

  def heated_tobacco_status_i18n
    self.class.human_enum_name(:heated_tobacco_status, heated_tobacco_status)
  end

  def papper_tobacco_status_i18n
    self.class.human_enum_name(:papper_tobacco_status, papper_tobacco_status)
  end

  private

  def sync_last_reported_at_for_related_shops
    related_shop_ids = [shop_id_before_last_save, shop_id].compact.uniq
    related_shop_ids.each { |id| self.class.sync_shop_last_reported_at!(id) }
  end

  def sync_last_reported_at_for_destroyed_shop
    target_shop_id = shop_id_before_last_save || shop_id
    return if target_shop_id.blank?

    self.class.sync_shop_last_reported_at!(target_shop_id)
  end

  def self.sync_shop_last_reported_at!(shop_id)
    latest_visited_on = where(shop_id: shop_id).maximum(:visited_on)
    last_reported_at = latest_visited_on&.in_time_zone&.end_of_day
    Shop.where(id: shop_id).update_all(last_reported_at: last_reported_at)
  end
end

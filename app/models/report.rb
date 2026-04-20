class Report < ApplicationRecord
  belongs_to :user
  belongs_to :shop

  after_commit :sync_shop_statuses_for_related_shops, on: [:create, :update]
  after_commit :sync_shop_statuses_for_destroyed_shop, on: :destroy

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

  def sync_shop_statuses_for_related_shops
    related_shop_ids = [shop_id_before_last_save, shop_id].compact.uniq
    related_shop_ids.each { |id| self.class.sync_shop!(id) }
  end

  def sync_shop_statuses_for_destroyed_shop
    target_shop_id = shop_id_before_last_save || shop_id
    return if target_shop_id.blank?

    self.class.sync_shop!(target_shop_id)
  end

  def self.sync_shop!(shop_id)
    latest = where(shop_id: shop_id).order(visited_on: :desc, created_at: :desc, id: :desc).first
    last_reported_at = latest&.visited_on&.in_time_zone&.end_of_day

    updates = { last_reported_at: last_reported_at }
    if latest
      updates[:heated_tobacco_status]  = latest.heated_tobacco_status_before_type_cast
      updates[:papper_tobacco_status]  = latest.papper_tobacco_status_before_type_cast
    end

    Shop.where(id: shop_id).update_all(updates)
  end
end

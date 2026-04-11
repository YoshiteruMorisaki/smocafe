class ShopTag < ApplicationRecord
  belongs_to :shop
  belongs_to :tag

  validates :shop_id, uniqueness: { scope: :tag_id }
end

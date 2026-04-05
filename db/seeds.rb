# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

admin = Admin.find_or_initialize_by(email_address: "admin@smocafe.local")
admin.password = "password"
admin.password_confirmation = "password"
admin.save!

user = User.find_or_initialize_by(email_address: "guest@smocafe.local")
user.name = "ゲストユーザー"
user.password = "password"
user.password_confirmation = "password"
user.is_active = true
user.save!

shop_areas = Shop::AREAS

shop_areas.each_with_index do |area, area_index|
	10.times do |shop_index|
		serial = shop_index + 1
		shop = Shop.find_or_initialize_by(name: "#{area}スモークカフェ#{serial}")
		shop.area = area
		shop.address = "東京都#{area}エリア#{serial}-#{area_index + 1}-#{serial}"
		shop.business_hours = format("%02d:00-%02d:00", 8 + (shop_index % 3), 20 + (shop_index % 4))
		shop.closed_days = ["なし", "月曜", "火曜", "水曜", "木曜"][shop_index % 5]
		shop.heated_tobacco_status = %w[unknown allowed disallowed][shop_index % 3]
		shop.papper_tobacco_status = %w[allowed disallowed unknown][shop_index % 3]
		shop.wifi_available = shop_index.even?
		shop.power_available = (shop_index % 3).zero?
		shop.description = "#{area}エリアのダミー店舗#{serial}です。喫煙可否、Wi-Fi、電源情報を確認できます。"
		shop.last_reported_at = Time.zone.parse("2026-04-01 09:00") + (area_index * 10 + shop_index).days
		shop.save!
	end
end

puts "Seeded admin: admin@smocafe.local / password"
puts "Seeded user: guest@smocafe.local / password"
puts "Seeded shops: #{Shop.where(area: shop_areas).count} records"

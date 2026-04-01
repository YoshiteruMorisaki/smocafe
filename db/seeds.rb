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

puts "Seeded admin: admin@smocafe.local / password"
puts "Seeded user: guest@smocafe.local / password"

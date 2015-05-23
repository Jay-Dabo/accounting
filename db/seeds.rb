# Generated with RailsBricks
# Initial seed file to use with Devise User Model

# Temporary admin account
# u = User.new(
#     email: "admin@example.com",
#     password: "asdasdasd",
#     password_confirmation: "asdasdasd",
#     first_name: "Galih",
#     last_name: "Muhammad",
#     phone_number: "081399279500",
#     admin: true
# )
# # u.skip_confirmation!
# u.save!

u = User.new(
    email: "galih0muhammad@gmail.com",
    password: "asdasdasd",
    password_confirmation: "asdasdasd",
    first_name: "Galih",
    last_name: "Muhammad",
    phone_number: "081399279500",
    admin: true
)
# u.skip_confirmation!
u.save!

v = User.new(
    email: "ph.prakosa@gmail.com",
    password: "rangkul1234",
    password_confirmation: "rangkul1234",
    first_name: "Pamungkas",
    last_name: "Hendra",
    phone_number: "083866333221",
    admin: true
)
# v.skip_confirmation!
v.save!

# a = Firm.new(
#     name: "Instilla", type: "Jasa", industry: "Teknologi",
#     starter_email: u.email, starter_phone: u.phone_number
#     )
# a.save


# Test user accounts
# (1..50).each do |i|
#   u = User.new(
#       email: "user#{i}@example.com",
#       password: "123123123",
#       password_confirmation: "123123123",
#       first_name: "User",
#       last_name: "#{i}",
#       phone_number: "00700700#{i}"
#   )
#   # u.skip_confirmation!
#   u.save!

#   puts "#{i} test users created..." if (i % 5 == 0)
# end

p1 = Plan.new(
    name: "Entri",
    duration: 30,
    price: 100000,
    description: "Bayar 100 ribu rupiah setiap bulannya untuk dapat akses"
)
p1.save!

# p3 = Plan.new(
#     name: "Loyal",
#     duration: 30,
#     price: 100000,
#     description: "Nikmati tagihan yang lebih murah dengan 
#                   membayar 300 ribu rupiah setiap 3 bulan untuk dapat akses"
# )
# p3.save!


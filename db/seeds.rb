# Generated with RailsBricks
# Initial seed file to use with Devise User Model

# Temporary admin account
u = User.new(
    email: "admin@example.com",
    password: "asdasdasd",
    password_confirmation: "asdasdasd",
    full_name: "GalihMuhammad",
    phone_number: "007007007",
    admin: true
)
u.skip_confirmation!
u.save!

# Test user accounts
(1..50).each do |i|
  u = User.new(
      email: "user#{i}@example.com",
      password: "123123123",
      password_confirmation: "123123123"
      full_name: "User#{i}",
      phone_number: "00700700#{i}"
  )
  u.skip_confirmation!
  u.save!

  puts "#{i} test users created..." if (i % 5 == 0)

p1 = Plan.new(
    name: "Icip",
    duration: 30,
    price: 150000
    description: "Bayar 150 ribu rupiah setiap bulannya untuk dapat akses"
    p1.save!
)

p3 = Plan.new(
    name: "Loyal",
    duration: 180,
    price: 100000
    description: "Nikmati tagihan yang lebih murah dengan 
                  membayar 600 ribu rupiah setiap 6 bulan untuk dapat akses"
    p3.save!
)

end

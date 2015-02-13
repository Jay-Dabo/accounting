def sign_up(user)
	fill_in("user[email]", with: "user@example.com", :match => :prefer_exact)
	fill_in("user[password]", with: "foobarbaz", :match => :prefer_exact)
	fill_in("user[password_confirmation]", with: "foobarbaz", :match => :prefer_exact)
	click_button  "Buat Akun"
end

def sign_in(user)
	visit new_user_session_path
	fill_in("user[email]", with: user.email, :match => :prefer_exact)
	fill_in("user[password]", with: user.password, :match => :prefer_exact)
	click_button  "Masuk"
end

def sign_out
  first(:link, "Sign Out").click
end

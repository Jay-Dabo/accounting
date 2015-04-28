source 'https://rubygems.org'
ruby '2.0.0'

# Standard Rails gems
gem 'rails', '4.2.0'
gem 'sass-rails', '5.0.2'
gem 'uglifier', '2.6.0'
gem 'coffee-rails', '4.1.0'
gem 'jquery-rails', '4.0.3'
gem 'turbolinks', '2.5.3'
gem 'jbuilder', '2.2.6'
gem 'bcrypt', '3.1.9'

# Necessary for Windows OS (won't install on *nix systems)
gem 'tzinfo-data', platforms: [:mingw, :mswin]

# Kaminari: https://github.com/amatsuda/kaminari
gem 'kaminari', '0.16.2'
# Friendly_id: https://github.com/norman/friendly_id
gem 'friendly_id', '5.1.0'
# Font-awesome: https://github.com/FortAwesome/font-awesome-sass
gem 'font-awesome-sass', '4.2.2'
# Bootstrap 3: https://github.com/twbs/bootstrap-sass
gem 'bootstrap-sass', '3.3.3'
gem 'bootstrap_form'
gem "cocoon"
gem 'autonumeric-rails'
gem "chartkick"
gem 'groupdate'

gem 'squeel'
gem 'reform'
gem 'ckeditor'
gem 'paperclip'
gem 'sanitize'
gem 'timecop'
gem 'amoeba'
# gem 'has_scope'
# gem 'reform'

# PDF gems
gem 'prawn'
gem 'prawn-table'

group :development do
	gem 'thin', '1.5.1'
end

group :development, :test do
  gem 'byebug', '3.5.1'
  gem 'web-console', '2.0.0'
  # Figaro: https://github.com/laserlemon/figaro
  gem 'figaro', '1.0.0'
  # Spring: https://github.com/rails/spring
  gem 'spring', '1.2.0'
  gem 'guard-rspec', require: false
  gem 'guard-livereload', require: false
  # gem 'spring-commands-rspec', '~> 1.0.4'
  gem 'wdm', '>= 0.1.0' if Gem.win_platform?
end

group :test, :development do
	gem 'rspec-rails', '3.1.0'
	gem 'capybara', '~> 2.2.0'
	gem 'factory_girl_rails', '4.5.0'
	gem 'database_cleaner', '1.3.0'
end

# PostgreSQL
gem 'pg'

# Devise: https://github.com/plataformatec/devise
gem 'devise', '3.4.1'

# Redcarpet: https://github.com/vmg/redcarpet
gem 'redcarpet', '3.2.2'

# Rails 12factor for Heroku: https://github.com/heroku/rails_12factor
group :production do
  gem 'rails_12factor'
end

# Unicorn: http://unicorn.bogomips.org
group :production do
  gem 'unicorn'
end